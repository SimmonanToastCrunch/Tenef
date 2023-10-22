extends Node2D


export(float) var stam_cost = 2.0


func _ready() -> void:
	var player = PlayerInventory.player
	if player != null:
		if player.stam >= stam_cost:
			show()
			player._remove_stamina(stam_cost)
		else:
			queue_free()
			return
	# set angle equal to the direction to the mouse cursor, plus some radians bc sprite is not facing straight up
	rotation = get_local_mouse_position().angle()
	$swing.play("swing")


func _on_swing_animation_finished(_anim_name):
	queue_free()
