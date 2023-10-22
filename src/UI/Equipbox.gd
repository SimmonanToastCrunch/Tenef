extends Node2D


signal itembox_clicked


enum armor_type {
	head,
	body,
	feet
}


export(armor_type) var type = armor_type.head


var item : Item = null

var offset : Vector2 = Vector2.ZERO

# if this item can be picked up or not
var pickable : bool = true

var child_info : Node = null


func _ready() -> void:
	if type == armor_type.body:
		$BaseSprite.texture = load("res://assets/art/ui/item_chest.png")
	elif type == armor_type.feet:
		$BaseSprite.texture = load("res://assets/art/ui/item_shoes.png")
	_set_item(ItemLookup._get_as_item("blank_item"))
	$Anims.play("box_zoom", -1, -1.0, true)
	remove_from_group("itemboxes")
	add_to_group("equipboxes")


func _update_self() -> void:
	_set_item(PlayerInventory.equipment[type])
	_update_sprites()


func _set_item(p_item : Item) -> void:
	item = p_item
	_update_sprites()


func _hide_box() -> void:
	pickable = false
	hide()


func _show_box() -> void:
	pickable = true
	show()


func _update_sprites() -> void:
	$BaseSprite/Weapon.texture = item.item_texture


func _on_item_button_pressed():
	if pickable:
		emit_signal("itembox_clicked", type)
		_delete_info()


func _on_mouse_entered():
	if pickable:
		$Anims.play("box_zoom")
		if item.item_name != "blank_item":
			_create_info()


func _on_mouse_exited():
	if pickable:
		$Anims.play("box_zoom", -1, -1.0, true)
	_delete_info()


func _update_selection() -> void:
	return


func _create_info() -> void:
	var instance = load("res://scenes/ui/ItemInfo.tscn").instance()
	instance._update_info(item)
	get_parent().add_child(instance)
	child_info = instance


func _delete_info() -> void:
	if child_info != null:
		child_info._delete()
		child_info = null
