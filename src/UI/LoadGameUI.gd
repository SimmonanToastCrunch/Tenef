extends Control


var entry : PackedScene = preload("res://scenes/ui/SaveGameEntry.tscn")
const vertical_buffer = 16


func _ready() -> void:
	# we must load in all known save files registries
	var file = File.new()
	if !file.file_exists("res://saves/data.json"):
		print("There are no saves!! Make a game first!")
		return
	
	file.open("res://saves/data.json", File.READ)
	var dict = SaveParser._to_dict(file.get_as_text())
	var saves = dict.saves
	
	_create_entries(saves)


func _create_entries(arr : Array) -> void:
	for i in range(arr.size()):
		var instance = entry.instance()
		instance.rect_position.x = 56
		instance.rect_position.y = vertical_buffer + (146 * i)
		instance._set_text(arr[i])
		instance.connect("load_pressed", self, "_on_load")
		$Base/List.add_child(instance)
	
	$Base/List/Scrollbar.max_value = 146 * (arr.size() - 3)
	if arr.size() > 3:
		$Base/List/Scrollbar.max_value += vertical_buffer
	


func _on_load(world_name) -> void:
	var file = File.new()
	if !file.file_exists("res://saves/" + world_name + ".json"):
		$Base/ErrorMessage.show()
		return
	Game.world_name = world_name
	Game.call_deferred("_change_level", "res://scenes/Overworld.tscn")


func _on_scroll(value) -> void:
	get_tree().call_group("savegameentry", "_on_scroll", value)


func _back() -> void:
	$Base/ErrorMessage.hide()
	hide()
