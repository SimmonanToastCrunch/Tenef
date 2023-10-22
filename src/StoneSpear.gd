extends Node2D

var wait_time : float = 0.67

func _ready():
	rotation = get_local_mouse_position().angle() + deg2rad(45)
	$Anims.play("attack")

func _on_Anims_animation_finished(_anim_name):
	queue_free()
