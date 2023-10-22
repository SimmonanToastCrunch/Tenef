# a class which determines how a world generator should work

#								#
#	~DEFAULT ISLAND GENERATOR~	#
#								#

class_name Generator
extends Node


const ClusterGroup = preload("res://src/dungeon/ClusterGroup.gd").ClusterGroup
var clustergroups : Array = [
	
]


var world_center = Vector2.ZERO
var noise = OpenSimplexNoise.new()


# misplaced code, move to descendant generators
var desired_tile_range_min : int = 50
var desired_tile_range_max : int = 100


# how many tiles should have structures
# float values 0.0 ~ 1.0
var structure_spawn_rate : float = 0.3

# arrays containing possible structures to be generated
# misplaced code, move to descendant generators
# structures to be generated on impassable spaces, like water or walls
var impassable_structures = [
	Structure.new("res://scenes/structures/BlankStruct.tscn", 0, 15, false),
	Structure.new("res://scenes/structures/Structure_Waterstone.tscn", 1),
]
# structures to be generated on passable spaces, like sand
var passable_structures = [
	Structure.new("res://scenes/structures/BlankStruct.tscn", 0, 10, false),
	Structure.new("res://scenes/structures/Structure_Driftwood.tscn", 1, 3),
	Structure.new("res://scenes/structures/Structure_Stone.tscn", 2, 1),
	Structure.new("res://scenes/structures/Structure_Tree.tscn", 3, 2)
]
# structures to be generated on topmost spaces, like grass
var topmost_structures  = [
	Structure.new("res://scenes/structures/BlankStruct.tscn", 0, 4, false),
	Structure.new("res://scenes/structures/Structure_Stone.tscn", 2, 1),
	Structure.new("res://scenes/structures/Structure_Tree.tscn", 3, 1),
	Structure.new("res://scenes/structures/Structure_Boulder.tscn", 4, 3)
]


func _ready() -> void:
	self.add_to_group("generator")


# called when a map is loaded in from disk
func _replace_structure(struct_id, tile_type) -> Structure:
	var ret = null
	var arr = []
	
	if tile_type == 0:
		arr = impassable_structures
	elif tile_type == 1:
		arr = passable_structures
	elif tile_type == 2:
		arr = topmost_structures
	
	for i in range(arr.size()):
		if arr[i].id == struct_id:
				ret = arr[i]
	
	return ret
	


func within(value, minimum, maximum) -> bool:
	if value <= minimum: # if value is less than minimum provided value, then it is not within
		return false
	elif value >= maximum: # if value is higher than maximum provided value, then it is not within
		return false
	else:
		return true # value is not greater than or less than provided boundaries, then it must be within


func _find_impassable_structure() -> Structure:
	var rand_value = rand_range(0, _get_total_weight(impassable_structures))
	for i in impassable_structures.size():
		# if the randomly generated number is within the weight of the currently iterated over structure, then that structure is decided
		if within(rand_value, 
		impassable_structures[i].weight_under, 
		# run quick structure spawn rate check here as well
		impassable_structures[i].weight_under + impassable_structures[i].weight):
			if randf() < structure_spawn_rate:
				return impassable_structures[i]
	# somehow the randomly generated value was unable to be calculated, something failed
	return null


func _find_passable_structure() -> Structure:
	var rand_value = rand_range(0, _get_total_weight(passable_structures))
	for i in passable_structures.size():
		# if the randomly generated number is within the weight of the currently iterated over structure, then that structure is decided
		if within(rand_value, 
		passable_structures[i].weight_under, 
		passable_structures[i].weight_under + passable_structures[i].weight):
			if randf() < structure_spawn_rate:
				return passable_structures[i]
	# somehow the randomly generated value was unable to be calculated, something failed
	return null


func _find_topmost_structure() -> Structure:
	var rand_value = rand_range(0, _get_total_weight(topmost_structures))
	for i in topmost_structures.size():
		# if the randomly generated number is within the weight of the currently iterated over structure, then that structure is decided
		if within(rand_value, 
		topmost_structures[i].weight_under, 
		topmost_structures[i].weight_under + topmost_structures[i].weight):
			if randf() < structure_spawn_rate:
				return topmost_structures[i]
	# somehow the randomly generated value was unable to be calculated, something failed
	return null


func _get_total_weight(array : Array) -> int:
	var total_weight = 0
	for i in array.size():
		# set the currently iterated over structures "under_weight" equal to total weight thus far. This is for use with weighted die rolls
		array[i].weight_under = total_weight
		total_weight += array[i].weight
	return total_weight


func _init() -> void:
	randomize()
	noise.seed = randi()
	noise.octaves = 5
	noise.period = 25.0
	noise.persistence = 1


func _generate_tile(tile : Vector2) -> float:
	var distance_from_center = 0.0
	distance_from_center = tile.distance_to(world_center)
	distance_from_center *= 0.1
	return noise.get_noise_2d(tile.x, tile.y) + distance_from_center


# should return a grid vector where the player's spawn should be. this can also be used to create dungeon exit/entrance
func _find_spawn(passable_spaces : PoolVector2Array, topmost_spaces : PoolVector2Array) -> Vector2:
	var rand_index : int = randi() % passable_spaces.size()
	var return_val = passable_spaces[rand_index]
	passable_spaces.remove(rand_index)
	return return_val


# should return the grid vector where the dungeon spawn should be. exit if 
func _find_dungeon_spawn(passable_spaces : PoolVector2Array, _topmost_spaces : PoolVector2Array) -> Vector2:
	var rand_index : int = randi() % passable_spaces.size()
	var return_val = passable_spaces[rand_index]
	passable_spaces.remove(rand_index)
	return return_val

# finds nearest available space to player
func _find_dungeon_exit(passable_spaces : PoolVector2Array, topmost_spaces : PoolVector2Array, player : Vector2) -> Vector2:
	var arr = topmost_spaces
	var lowest = 0
	var nearest = Vector2.ZERO
	var nearestind = 0
	
	for i in range(arr.size()):
		var distance = player.distance_to(arr[i])
		if distance <= lowest:
			lowest = distance
			nearest = arr[i]
			nearestind = i
	
	topmost_spaces.remove(nearestind)
	return nearest


# used to find and place "clusters" aka enemy spawn points
# default generator has sample logic for this because enemies do not normally spawn on the overworld
func _place_clusters(passable : Array, topmost : Array) -> void:
	return
	for i in topmost:
		var instance = load("res://scenes/dungeons/Cluster.tscn").instance()
		instance.position = Vector2(i.x * 48, i.y * 48)
		get_parent().call_deferred("add_child", instance)


	# a function which should decide which tilemap a tile should belong to
	# 0 if impassable
	# 1 if passable
	# 2 if topmost
func _tile_type(value : float) -> int:
	if value > 0.9:
		return 0
	elif value > 0.62:
		return 1
	else:
		return 2
