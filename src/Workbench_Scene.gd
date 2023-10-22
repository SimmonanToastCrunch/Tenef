extends Node2D


func _ready() -> void:
	var mouse_pos = get_global_mouse_position()
	var level : Node = null
	if get_tree().has_group("level"):
		level = get_tree().get_nodes_in_group("level")[0]
	if level != null:
		if !level.buildable:
			# if we cannot build here then simply delete self
			queue_free()
			return
	if BuildingInfo._check_position(BuildingInfo._to_grid(mouse_pos)):
		var instance = load("res://scenes/structures/Building_Workbench.tscn").instance()
		instance.position = BuildingInfo._to_grid(get_global_mouse_position()) * BuildingInfo.cell_size
		BuildingInfo._add_building(instance, instance.position * BuildingInfo.cell_size)
		get_parent().get_parent().call_deferred("add_child", instance)
		_remove_workbench()
		# delete ghost buildings
		get_tree().call_group("ghost_building", "queue_free")
	queue_free()


func _remove_workbench() -> void:
	var item = ItemLookup._get_as_item("Workbench")
	item.amount = 1
	PlayerInventory.player._remove_item(item)
