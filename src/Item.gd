class_name Item
extends Node


enum equip_type {
	none,
	head,
	body,
	feet,
	trinket
}


var item_name : String # name of the item
var item_texture : Texture # texture resource of this item
var ghost_texture : Texture #  texture of the ghost texture, leave null for no ghost texture
var item_description : String # description of the item
var quality : Color # what color this item should show as in item info boxes
var amount : int # how many items are stored here
var max_amount : int # how many items maximum can be stored here
var on_use : PackedScene # this is the scene that will be instantiated when this item is used
var cursed : bool = false
var armor_type : int = equip_type.none
var defense : int = 0


onready var default_texture = load("res://assets/art/item/item_blank.png")
var default_use = load(ItemLookup.default_scene)


# takes in a number of items to add to this item. returns the remainder if this stack cannot support more items
func _add_stack(p_amount : int) -> int:
	if amount + p_amount > max_amount:
		# item cannot fit
		var amount_needed : int = max_amount - amount # this is the remaining "space" left in the item stack before we change any values
		amount = max_amount
		p_amount -= amount_needed # p_amount is now equal to amount that cannot be filled, not enough room
		return p_amount
		
	else:
		# item can fit
		amount += p_amount
		return 0


# functions similar to _add_stack but removes items. returns 0 if successful or the remainder if some items couldn't be removed
func _remove_stack(p_amount : int) -> int:
	if amount - p_amount < 0:
		# item cannot fit
		# warning-ignore:narrowing_conversion
		var amount_needed : int = abs(amount - p_amount) # this is the items we cannot take bc there is not enough space
		_clear_item()
		return amount_needed
		
	else:
		# item can fit
		amount -= p_amount
		if amount == 0:
			_clear_item()
		return 0


func _set_item(item : Item) -> void:
	item_name = item.item_name
	item_texture = item.item_texture
	item_description = item.item_description
	quality = item.quality
	amount = item.amount
	max_amount = item.max_amount
	on_use = item.on_use
	ghost_texture = item.ghost_texture
	cursed = item.cursed
	armor_type = item.armor_type
	defense = item.defense


func _init(
	p_item_name : String = "blank_item", 
	p_item_texture : Texture = default_texture,
	p_item_description : String = "nothin",
	p_quality : Color = ItemLookup.quality_common,
	p_amount : int = 1,
	p_max_amount : int = 1, 
	p_on_use : PackedScene = default_use,
	p_ghost_texture : Texture = null,
	p_cursed : bool = false,
	p_armor_type : int = equip_type.none,
	p_defense : int = 0
	):
	item_name = p_item_name
	item_texture = p_item_texture
	item_description = p_item_description
	quality = p_quality
	amount = p_amount
	max_amount = p_max_amount
	on_use = p_on_use
	ghost_texture = p_ghost_texture
	cursed = p_cursed
	armor_type = p_armor_type
	defense = p_defense


# removes this item and makes it a blank item
func _clear_item() -> void:
	var item : Item = ItemLookup._get_as_item("blank_item")
	_set_item(item)


# returns true if this item is not at max stack
func _available() -> bool:
	return amount < max_amount


#		FUNCTIONS RELATED TO ITEM USAGE		#
func _use(parent) -> void:
	var instance = on_use.instance()
	instance.connect("tree_exited", parent, "_on_use_finish")
	#instance.position = parent.position
	parent.add_child(instance)


