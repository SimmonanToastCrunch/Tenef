extends Node2D


func _ready() -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_pos = BuildingInfo._to_grid(mouse_pos)
	if BuildingInfo._check_position(grid_pos):
		var instance = load("res://scenes/structures/Building_Smeltingkit.tscn").instance()
		instance.position = grid_pos * BuildingInfo.cell_size
		BuildingInfo._add_building(instance, grid_pos)
		get_parent().get_parent().call_deferred("add_child", instance) # player -> level.add_child
		get_tree().call_group("ghost_building", "queue_free")
	_remove_smeltingkit()
	queue_free()


func _remove_smeltingkit() -> void:
	var item = ItemLookup._get_as_item("Smelting Kit")
	item.amount = 1
	PlayerInventory.player._remove_item(item)
