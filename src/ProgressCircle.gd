class_name ProgressCircle
extends Node2D


tool


var fill_percent : float = 0.0
export(float) var max_value = 100.0
export(float) var value = 0.0
export(float) var radius = 32.0
export(int) var point_coint = 360
export(Color) var color = Color(1.0, 1.0, 1.0, 1.0)


func _process(_delta):
	if Engine.is_editor_hint():
		update()
	else:
		value = clamp(value, 0.0, max_value)


func _draw() -> void:
	var percent : float = value / max_value
	percent *= 360
	fill_percent = percent
	if Engine.is_editor_hint():
		draw_arc(Vector2.ZERO, radius, deg2rad(-90), deg2rad(fill_percent - 90), point_coint, color, radius, true)
	else:
		draw_arc(Vector2.ZERO, radius, deg2rad(-90), deg2rad(fill_percent - 90), point_coint, color, radius, true)

