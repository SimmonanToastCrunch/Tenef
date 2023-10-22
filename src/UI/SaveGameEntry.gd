extends Control


signal load_pressed(world_name)


var base_pos : Vector2 = Vector2.ZERO
var save_name : String = ""


func _ready() -> void:
	base_pos = rect_position


func _set_text(newtext) -> void:
	save_name = newtext
	$Base/Panel/Label.text = save_name


func _on_scroll(value) -> void:
	rect_position.y = base_pos.y - value


func _on_pressed() -> void:
	emit_signal("load_pressed", save_name)
