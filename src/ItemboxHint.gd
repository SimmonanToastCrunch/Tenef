extends Node2D


signal add_to_array(Node)


var item : Item

var child_info : Node = null
export(String, "result_box", "cost_box") var base_texture = "result_box"


func _ready():
	var t_item = ItemLookup._get_as_item("blank_item")
	_set_item(t_item)
	emit_signal("add_to_array", self)
	$Anims.play("box_zoom", -1, -1.0, true)
	
	if base_texture == "result_box":
		$BaseSprite.texture = load("res://assets/art/ui/item_box_result.png")
	else:
		$BaseSprite.texture = load("res://assets/art/ui/item_box_delete.png")


func _set_item(p_item : Item) -> void:
	item = p_item
	_update_self()


func _clear_item() -> void:
	item = ItemLookup._get_as_item("blank_item")
	_update_self()


func _show_box() -> void:
	show()


func _update_self() -> void:
	if item.item_name != "blank_item":
		$BaseSprite/Weapon.show()
		$Amount.show()
		$BaseSprite/Weapon.texture = item.item_texture
		$Amount.text = str(item.amount)
	else:
		$BaseSprite/Weapon.hide()
		$Amount.hide()


func _create_info() -> void:
	var instance = load("res://scenes/ui/ItemInfo.tscn").instance()
	instance._update_info(item)
	get_parent().get_parent().add_child(instance)
	child_info = instance


func _delete_info() -> void:
	if child_info != null:
		child_info._delete()
		child_info = null


func _add_self_to_array() -> void:
	if base_texture == "cost_box":
		emit_signal("add_to_array", self)


func _on_mouse_entered():
	if item.item_name != "blank_item":
		_create_info()


func _on_mouse_exited():
	if item.item_name != "blank_item":
		_delete_info()


func _on_itembox_visibility_changed():
	_delete_info()
