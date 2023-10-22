extends Node

signal deleted

var stored_item : Item

func _on_helditem_tree_exiting():
	Game._reset_pointer()
	emit_signal("deleted")

func _update_cursor() -> void:
	Input.set_custom_mouse_cursor(stored_item.item_texture)

func _get_name() -> String:
	return stored_item.item_name

func _get_amount() -> int:
	return stored_item.amount
