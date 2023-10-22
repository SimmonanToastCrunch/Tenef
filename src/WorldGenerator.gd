class_name WorldGenerator
extends Node

export var cell_size = Vector2(48, 48)
# how many tiles large this world should be
export var world_size = Vector2(24, 24)

# class containing methods about how to generate a world
var generator : Generator

# tilemap according to what spaces should be blocking the player. Like water
var tilemap_impassable_space : TileMap
# tilemap according to what spaces should be passable by the player. Like sand
var tilemap_passable_space : TileMap
# tilemap according to what spaces should be topmost and passable by the player
var tilemap_top_space : TileMap
# tilemap which contains navigation data. used for pathfinding
var tilemap_navigation : TileMap

func within(value, minimum, maximum) -> bool:
	if value <= minimum: # if value is less than minimum provided value, then it is not within
		return false
	elif value >= maximum: # if value is higher than maximum provided value, then it is not within
		return false
	else:
		return true # value is not greater than or less than provided boundaries, then it must be within


func _init_generator():
	generator.world_center = Vector2(world_size.x / 2, world_size.y / 2)
	self.add_child(generator)


func _load() -> void:
	print("Load")
	var file = SaveParser._open_file_r("res://saves/" + Game.world_name + ".json")
	var dat = file.get_as_text()
	file.close()
	# convert str to dictionary so we can use the numbers
	dat = SaveParser._to_dict(dat)
	
	# first update all tiles
	for i in range(dat.world.tiles.size()):
		var entry = dat.world.tiles[i]
		var tile_type = entry[2]
		if tile_type == 0:
			tilemap_impassable_space.set_cell(entry[0], entry[1], 0)
		elif tile_type == 1:
			tilemap_passable_space.set_cell(entry[0], entry[1], 0)
		elif tile_type == 2:
			tilemap_top_space.set_cell(entry[0], entry[1], 0)
		# handle structures
		var structure = generator._replace_structure(entry[3], entry[2])
		var struct = [entry[0], entry[1], entry[3]]
		BuildingInfo.structures.push_back(struct)
		if structure != null:
			var instance = structure.scene.instance()
			instance.position = Vector2(cell_size.x * entry[0], cell_size.y * entry[1])
			get_parent().call_deferred("add_child", instance)
			
	
	_clean_tilemaps()
	
	# handle player spawn
	var player_spawn = get_tree().get_nodes_in_group("player_spawn")[0]
	var position = Vector2(dat.world.spawn[0], dat.world.spawn[1])
	player_spawn.position = position
	
	# manually set player spawn bc I didn't streamline this bc I'm retarded
	yield(get_tree(), "idle_frame")
	get_tree().get_nodes_in_group("player")[0].global_position = player_spawn.position
	
	var entrance = load("res://scenes/structures/DungeonEntrance.tscn").instance()
	entrance.position = Vector2(dat.world.dungeon_spawn[0], dat.world.dungeon_spawn[1])
	get_parent().call_deferred("add_child", entrance)
	


# saves the contents of this world to a json file
func _save(world_dat) -> void:
	var file = File.new()
	file.open("res://saves/" + Game.world_name + ".json", File.WRITE)
	file.store_string(world_dat)


func _ready() -> void:
	self.add_to_group("world_generator")
	tilemap_impassable_space = get_tree().get_nodes_in_group("tilemap_impassable")[0]
	tilemap_passable_space = get_tree().get_nodes_in_group("tilemap_passable")[0]
	tilemap_top_space = get_tree().get_nodes_in_group("tilemap_topmost")[0]
	tilemap_navigation = get_tree().get_nodes_in_group("tilemap_navigation")[0]

# returns true if the correct amount of tiles were generated
func _generate_world(save_world : bool = false, generate_exit : bool = true) -> int:
	var world_dat = {"world": {
		"tiles": [],
		"spawn": [],
		"dungeon_spawn": [],
	}}
	# an array storing grid positions of passable passable spaces
	var passable_space_arr : PoolVector2Array = []
	# an array storing grid positions of passable topmost spaces
	var topmost_space_arr : PoolVector2Array = []
	
	# similar to above but stores tiles that are occupied as well
	var passable_tile_arr : PoolVector2Array = []
	var topmost_tile_arr : PoolVector2Array = []
	
	BuildingInfo._reset()
	for y in range(world_size.y):
		for x in range(world_size.x):
			var mark_passable_space : bool = true # set to false if the generated tile is impassable, to mark navigation tilemap
			var tile_type = generator._tile_type(generator._generate_tile(Vector2(x, y)))
			var structid = 0
			
			match tile_type:
				0: 
					var struct = generator._find_impassable_structure()
					if struct != null: # structure generation successful/passed
						var instance = struct.scene.instance()
						instance.position = Vector2(x * cell_size.x, y * cell_size.y)
						BuildingInfo.grid[Vector2(x, y)] = instance
						get_parent().add_child(instance)
						structid = struct.id
					else:
						# make an entry in building info anyway, because you shouldn't be able to build on water
						BuildingInfo.grid[Vector2(x, y)] = null
					tilemap_impassable_space.set_cell(x, y, 0)
					mark_passable_space = false
				1: 
					var struct = generator._find_passable_structure()
					if struct != null:
						var instance = struct.scene.instance()
						instance.position = Vector2(x * cell_size.x, y * cell_size.y)
						# there's a building in this position, this tile is not passable
						if struct.occupied:
							mark_passable_space = false
							BuildingInfo.grid[Vector2(x, y)] = instance
						else: # there's no building in this position, mark this tile as passable in passable_space_arr
							passable_space_arr.push_back(Vector2(x, y))
						get_parent().add_child(instance)
						structid = struct.id
						#deprecated code. keeping around for archeological purposes
#					else:
#						# mark this as passable in navigation mesh because no structure
#						print("Tile at x: " + str(x), " y: " + str(y) + " Generated tile with array: " + str(AI._get_outline_from_tile(Vector2(x, y), cell_size)))
#						AI._add_outline(AI._get_outline_from_tile(Vector2(x, y), cell_size))
					passable_tile_arr.push_back(Vector2(x, y))
					tilemap_passable_space.set_cell(x, y, 0)
				2: 
					var struct = generator._find_topmost_structure()
					if struct != null:
						var instance = struct.scene.instance()
						instance.position = Vector2(x * cell_size.x, y * cell_size.y)
						if struct.occupied:
							mark_passable_space = false
							BuildingInfo.grid[Vector2(x, y)] = instance
						else: # there's no building in this position, mark this tile as passable in passable_space_arr
							topmost_space_arr.push_back(Vector2(x, y))
						get_parent().add_child(instance)
						structid = struct.id
					tilemap_top_space.set_cell(x, y, 0)
					topmost_tile_arr.push_back(Vector2(x, y))
				# tile generation done, mark navigation tilemap if passable space
			if mark_passable_space:
				tilemap_navigation.set_cell(x, y, 0)
			var entry = [x, y, tile_type, structid]
			world_dat.world.tiles.push_back(entry)
			var buildentry = [x, y, structid]
			BuildingInfo.structures.push_back(buildentry)
	Game._update_singleton()
	
	generator._place_clusters(passable_tile_arr, topmost_tile_arr)
	
	# set the position of the player's spawn to whatever the generator wants it to be
	var player_spawn = get_tree().get_nodes_in_group("player_spawn")[0]
	# set the position of the player's spawn to to world coordinates of wherever the generator points
	var player_spawn_tile : Vector2 = generator._find_spawn(passable_space_arr, topmost_space_arr)
	player_spawn.position = tilemap_top_space.map_to_world(player_spawn_tile)
	player_spawn.position += (cell_size * 0.5) # adjust the player's position so that it's in the center of the tile instead of top left corner
	world_dat.world.spawn.push_back(player_spawn.position.x)
	world_dat.world.spawn.push_back(player_spawn.position.y)
	
	# load in entrance instance
	var entrance_instance = load("res://scenes/structures/DungeonEntrance.tscn").instance()
	var entrance_position = generator._find_dungeon_spawn(passable_space_arr, topmost_space_arr)
	entrance_instance.position = tilemap_top_space.map_to_world(entrance_position)
	world_dat.world.dungeon_spawn.push_back(entrance_instance.position.x)
	world_dat.world.dungeon_spawn.push_back(entrance_instance.position.y)
	
	
	if generate_exit:
		var exit_instance = load("res://scenes/structures/DungeonExit.tscn").instance()
		var exit_position = generator._find_dungeon_exit(passable_space_arr, topmost_space_arr, player_spawn_tile)
		exit_instance.position = tilemap_top_space.map_to_world(exit_position)
		get_parent().add_child(exit_instance)
	
	BuildingInfo.call_deferred("_add_building", entrance_instance, entrance_position)
	get_parent().add_child(entrance_instance)
	
	if save_world:
		Game._save(world_dat)
	
	_clean_tilemaps()
	
	return passable_space_arr.size() + topmost_space_arr.size()


func _clean_tilemaps() -> void:
	tilemap_impassable_space.update_dirty_quadrants()
	tilemap_passable_space.update_dirty_quadrants()
	tilemap_top_space.update_dirty_quadrants()
