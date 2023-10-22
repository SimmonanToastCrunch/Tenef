extends Node


var saves_path : String = "res://saves/"
var world_name : String = "world"


var dungeon_pool : Array = [
	"res://scenes/dungeons/Subsurface.tscn",
]


var floor_number : int = 0


var cursor_icon = preload("res://assets/art/ui/pointer.png")


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	var structures : Array = get_tree().get_nodes_in_group("structure")
	for structure in structures:
		structure.connect("exit", self, "_structure_exit")


func _unload_level() -> void:
	if get_tree().has_group("level"):
		print("Main level exists, deleting main level")
		get_tree().get_nodes_in_group("level")[0].free()


func _load_level(p_level : String) -> void:
	var level_instance = load(p_level).instance()
	get_tree().get_root().add_child(level_instance)
	print(floor_number)


func _change_level(p_level : String) -> void:
	_unload_level()
	yield(get_tree(), "idle_frame")
	_load_level(p_level)
	yield(get_tree(), "idle_frame")
	_update_singleton()


func _update_singleton() -> void:
	AI._update()
	BuildingInfo._update()


func _create_dungeon() -> void:
	var rand_index : int = randi() % dungeon_pool.size()
	var next_level : String = dungeon_pool[rand_index]
	floor_number += 1
	call_deferred("_change_level", next_level)


func _set_player_position() -> void:
	if get_tree().has_group("player") and get_tree().has_group("player_spawn"):
		var player = get_tree().get_nodes_in_group("player")[0]
		var player_spawn = get_tree().get_nodes_in_group("player_spawn")[0]
		player.global_position = player_spawn.position
		


func _load():
	var file = File.new()
	file.open(saves_path + world_name + ".json", File.READ)
	var text = file.get_as_text()
	file.close()
	return SaveParser._to_dict(JSON.parse(text))


func _save(world_dict) -> void:
	var file = File.new()
	file.open("res://saves/" + world_name + ".json", File.WRITE)
	var world_str = SaveParser._to_json(world_dict)
	file.store_string(world_str)
	file.close()
	
	#now we must check if this save is registered!
	#if not, register it now
	
	# does register exist?
	# create it if it does not
	if !file.file_exists("res://saves/data.json"):
		var base_dat = {
			"saves": []
		}
		file.open("res://saves/data.json", File.WRITE)
		var json = SaveParser._to_json(base_dat)
		file.store_string(json)
		file.close()
	
	file.open("res://saves/data.json", File.READ_WRITE)
	var dict = SaveParser._to_dict(file.get_as_text())
	if !dict.saves.has(world_name):
		dict.saves.push_back(world_name)
	file.store_string(SaveParser._to_json(dict))
	file.close()
	print("Saved")
	# :)


func _structure_exit(structure) -> void:
	var file = File.new()
	file.open("res://saves/" + world_name + ".json", File.READ)
	var world_data = SaveParser._to_dict(file.get_as_text())
	file.close()
	
	structure.grid_postion = BuildingInfo._to_grid(structure.global_position)
	var index = (28 * structure.grid_postion.y) + structure.grid_postion.x # get index of this object
	
	world_data.world.tiles[index][3] = 0
	
	_save(world_data)


func _exit_tree() -> void:
	pass


func _reset_pointer() -> void:
	Input.set_custom_mouse_cursor(cursor_icon)
