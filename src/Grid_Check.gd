extends Sprite


var buildable : bool = true


func _ready() -> void:
	if get_tree().has_group("level"):
		buildable = get_tree().get_nodes_in_group("level")[0].buildable


func _physics_process(_delta) -> void:
	position = BuildingInfo._to_world(BuildingInfo._to_grid(get_global_mouse_position()))
	if BuildingInfo._check_position(BuildingInfo._to_grid(get_global_mouse_position())) and buildable:
		modulate = Color(0.0, 1.0, 0.0)
	else:
		modulate = Color(1.0, 0.0, 0.0)
