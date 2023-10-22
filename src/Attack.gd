extends Node2D

export(float) var swing_speed = 0.7
export(PackedScene) var projectile

func _ready():
	$Animations.play("swing", -1, swing_speed)

func _on_Animations_animation_finished(_anim_name):
	queue_free()


func _on_Animations_animation_started(_anim_name):
	var instance = projectile.instance()
	var angle = ( position.angle_to_point( get_local_mouse_position() ) + deg2rad(180) )
	rotation = angle
	instance.position = get_parent().position
	get_parent().get_parent().call_deferred("add_child", instance)
