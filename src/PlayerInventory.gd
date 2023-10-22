extends Inventory


var equipment : Array = [
	Item.new(),
	Item.new(),
	Item.new()
]


var selection_index : int = 0
var player : Node = null


var gold : int = 0


func _reset_size() -> void:
	_resize_inventory(15)


func _ready() -> void:
	_reset_size()


func _fetch_player() -> void:
	if get_tree().has_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]


# deletes all item boxes and recreates them
func _reset_inventory_ui() -> void:
	if get_tree().has_group("InventoryUI"):
		var inventoryui = get_tree().get_nodes_in_group("InventoryUI")[0]
		inventoryui._create_item_boxes()


# simply refreshes item boxes
func _update_inventory_ui() -> void:
	if get_tree().has_group("InventoryUI"):
		var inventoryui = get_tree().get_nodes_in_group("InventoryUI")[0]
		inventoryui._update_inventory()


func _add_gold(amount : int) -> void:
	gold += amount
	player._update_gold()


func _remove_gold(amount : int) -> void:
	gold -= amount
	player._update_gold()


func _set_gold(amount : int) -> void:
	gold = amount


func _remove_cursed_items() -> void:
	for i in storage.size():
		if storage[i].cursed:
			storage[i]._clear_item()
	for i in equipment.size():
		if equipment[i].cursed:
			equipment[i]._clear_item()
	gold = 0
	player._update_gold()
	_update_inventory_ui()


func _print_defense() -> void:
	var sum : int = 0 
	for i in range(equipment.size()):
		sum += equipment[i].defense
	print(sum)
