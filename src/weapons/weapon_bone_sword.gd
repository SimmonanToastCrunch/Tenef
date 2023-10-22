extends Node2D


export(float)var stam_cost = 3.0


func _ready() -> void:
	var player = PlayerInventory.player
	if player != null:
		if player.stam >= stam_cost:
			show()
			player._remove_stamina(stam_cost)
		else:
			queue_free()
			return
	rotation = get_local_mouse_position().angle()
	$Anims.play("swing")


func _anim_over(_anim) -> void:
	queue_free()
