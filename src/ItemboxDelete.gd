extends Node2D

signal trash_clicked

func _ready() -> void:
	hide()

func _hide_box() -> void:
	hide()

func _show_box() -> void:
	show()

func _on_item_button_pressed():
	emit_signal("trash_clicked")
