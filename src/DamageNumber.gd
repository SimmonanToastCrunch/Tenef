extends Node2D

func _ready() -> void:
	$Anims.play("Float")


func _set_text(p_text : String) -> void:
	$Number.text = p_text


func _on_animation_finished(_anim_name):
	queue_free()


