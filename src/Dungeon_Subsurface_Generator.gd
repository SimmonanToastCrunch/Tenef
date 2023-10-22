class_name SubsurfaceGenerator
extends Generator


var world_size : Vector2 = Vector2.ZERO
var tile_data : PoolRealArray = []


var spawnedcircles : Array = []


const Circle = preload("res://src/prefabs/Circle.gd").Circle


func _init() -> void:
	structure_spawn_rate = 0.8
	passable_structures = [
		Structure.new("res://scenes/structures/BlankStruct.tscn", 0, 3, false),
		Structure.new("res://scenes/structures/Structure_Stone.tscn", 0, 1),
		Structure.new("res://scenes/structures/Structure_Boulder.tscn", 0, 2),
		Structure.new("res://scenes/structures/Structure_Iron.tscn", 0, 1),
		Structure.new("res://scenes/structures/Structure_Root.tscn", 0, 4)
	]
	topmost_structures = [
		Structure.new("res://scenes/structures/BlankStruct.tscn", 0, 90, false),
		Structure.new("res://scenes/structures/Structure_Stone.tscn", 0, 6),
		Structure.new("res://scenes/structures/Structure_Boulder.tscn", 0, 1),
		Structure.new("res://scenes/structures/Structure_Silver.tscn", 0, 1),
		Structure.new("res://scenes/structures/Crate.tscn", 0, 4),
	]
	clustergroups = [
		load("res://scenes/enemies/EnemyDinosaur.tscn")
	]
	


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	
	if get_tree().has_group("world_generator"):
		var worldgen = get_tree().get_nodes_in_group("world_generator")[0]
		world_size = worldgen.world_size
		tile_data.resize(world_size.x * world_size.y)
		_generate_circles()

func _generate_circles() -> void:
	var tiles : PoolVector2Array = []
	tile_data.fill(0.0)
	for y in range(world_size.y):
		for x in range(world_size.x):
			tiles.push_back(Vector2(x, y))
	
	var circle = Circle.new(Vector2.ZERO, 0)
	
	# generate around ~200 tiles worth of circles clumped together-ish
	for i in range(rand_range(4, 7)):
		var rand_position : Vector2 = Vector2.ZERO
		var rand_rad : int = rand_range(4, 8)
		rand_position = Vector2(rand_rad + rand_range(3, 15), rand_rad + rand_range(3, 15))
		circle.center = rand_position
		circle.radius = rand_rad
		spawnedcircles.push_back(rand_position)
		tile_data = circle._apply_circle(tiles, tile_data)
	


func _place_clusters(_pass, _top) -> void:
	for i in spawnedcircles.size():
		var instance = load("res://scenes/dungeons/Cluster.tscn").instance()
		instance.position = spawnedcircles[i]
		instance.position *= 48
		get_parent().call_deferred("add_child", instance)
	spawnedcircles.clear()


func _generate_tile(tile : Vector2) -> float:
#	var distance_from_center = 0.0
#	distance_from_center = tile.distance_to(world_center)
#	distance_from_center *= 0.001
#	return noise.get_noise_2d(tile.x, tile.y)# - distance_from_center
	# convert tile position to index
	var ind = (tile.y * world_size.y) + tile.x
	return float(tile_data[ind])


# should return a grid vector where the player's spawn should be. this can also be used to create dungeon exit/entrance
func _find_spawn(passable_spaces : PoolVector2Array, topmost_spaces : PoolVector2Array) -> Vector2:
	var rand_index : int = 0
	var return_val = 0
	if topmost_spaces.size() != 0:
		rand_index = randi() % topmost_spaces.size()
		return_val = topmost_spaces[rand_index]
		topmost_spaces.remove(rand_index)
	else:
		rand_index = randi() % passable_spaces.size()
		return_val = passable_spaces[rand_index]
		passable_spaces.remove(rand_index)
	return return_val


func _find_dungeon_spawn(passable_spaces : PoolVector2Array, topmost_spaces : PoolVector2Array) -> Vector2:
	var arr = passable_spaces
	var rand_index : int = randi() % arr.size()
	var return_val = arr[rand_index]
	arr.remove(rand_index)
	return return_val


func _tile_type(value : float) -> int:
	if value > 0.8:
		return 2
	elif value > 0.1:
		return 1
	else:
		return 0

