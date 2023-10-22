extends Button

# the default position of this crafting option
var def_y : int

const Recipe = preload("res://src/Recipe.gd").Recipe

signal option_selected(Recipe)

var recipe : Recipe = null


func _on_crafting_ption_pressed():
	emit_signal("option_selected", recipe)


func _on_scroll(value : int) -> void:
	rect_position.y = def_y - value
