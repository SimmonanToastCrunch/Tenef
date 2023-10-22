extends Node2D

signal itembox_clicked

var item : Item = null
# the position in the players inventory this item is meant to correspond to
var index : int = 0

var rowx : int = 5
var offset : Vector2 = Vector2.ZERO

# if this item can be picked up or not
var pickable : bool = false

var child_info : Node = null

func _ready():
	_set_item(ItemLookup._get_as_item("blank_item"))
	$Anims.play("box_zoom", -1, -1.0, true)

func _update_self() -> void:
	_set_item(PlayerInventory.storage[index])
	if ItemLookup._get_as_item(item.item_name).item_name == "blank_item":
		$Amount.hide()
	else:
		$Amount.show()
	$Amount.text = str(item.amount)
	_update_sprites()

func _set_item(p_item : Item) -> void:
	item = p_item
	_update_sprites()

func _hide_box() -> void:
	if index < rowx:
		# if this item is in tool bar, don't hide, just move
		$BaseSprite.scale = Vector2(1, 1)
		$Amount.rect_position = Vector2(0, 16)
		$ItemButton.rect_size = Vector2(96, 96)
		$ItemButton.rect_position = Vector2(-48, -48)
		pickable = false
		position.x -= 64
		position.y -= 64
	else:
		hide()

func _show_box() -> void:
	pickable = true
	if index < rowx:
			position.x += 64
			position.y += 64
	show()

func _update_sprites() -> void:
	$BaseSprite/Weapon.texture = item.item_texture

func _on_item_button_pressed():
	if pickable:
		emit_signal("itembox_clicked", index, self)
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
	if index == PlayerInventory.selection_index:
		$Selection.show()
	else:
		$Selection.hide()

func _create_info() -> void:
	var instance = load("res://scenes/ui/ItemInfo.tscn").instance()
	instance._update_info(item)
	get_parent().add_child(instance)
	child_info = instance

func _delete_info() -> void:
	if child_info != null:
		child_info._delete()
		child_info = null
