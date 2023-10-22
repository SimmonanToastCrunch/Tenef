extends Node2D

func _ready() -> void:
	var instance = load("res://scenes/structures/Collapsed_Tree.tscn").instance()
	instance.position = BuildingInfo._to_grid(get_global_mouse_position()) * BuildingInfo.cell_size
	get_parent().get_parent().call_deferred("add_child", instance)
	BuildingInfo._add_building(instance, BuildingInfo._to_grid(get_global_mouse_position()) * BuildingInfo.cell_size)
	queue_free()
