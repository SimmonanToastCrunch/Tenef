extends StaticBody2D

export var interact_range : int = 100

# hrrngh https://youtu.be/vQUF9M7horo


func _on_interact() -> void:
	yield(get_tree(), "idle_frame")
	var player : Node2D = null
	if get_tree().has_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]
	else:
		print("Hrrrngh no player detected wtf (dungeon exit broken)")
		return
	
	if player.global_position.distance_to(self.global_position) <= interact_range:
		_interact()
	


func _interact() -> void:
	Game.call_deferred("_change_level", "res://scenes/Overworld.tscn")
	PlayerInventory._remove_cursed_items()
