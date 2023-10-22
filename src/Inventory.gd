class_name Inventory
extends Node

# storage var for items
var storage = []
# storage/memory/whatever for all items collected
# keeps track of adding/removing items
var storage_history : Dictionary = {

}

var inventory_size : int # how many items this inventory can store

func _init(p_size : int = 5):
	inventory_size = p_size
	for i in inventory_size:
		storage.push_back(Item.new())

func _resize_inventory(new_amount : int) -> void:
	inventory_size = new_amount
	if new_amount < storage.size(): # if inventory is getting smaller
		storage.resize(new_amount) # let godot take care of erasing
	elif new_amount == storage.size():
		return
	elif new_amount > storage.size(): # if inventory is getting bigger
		var size_change = (new_amount - storage.size())
		for i in size_change:
			storage.push_back(Item.new())

# essentially only exists to clean code
# returns 0 if all items were filled, some number if there is a remainder
func _fill_item(item : Item, p_amount : int) -> int:
	# fill all currently existing copies of this item with space
	var remainder = p_amount
	while(remainder != 0): # while there is still an amount left in remainder, search for a spot to place this item
		var index = _find_available_item(item)
		if index == -1: # if there is no available item, then that means there are no more item spots to fill
			return remainder # so break this while loop
		remainder = storage[index]._add_stack(remainder)
	# if by all odds all items were filled, then we return 0
	return 0

func _unfill_item(item : Item, p_amount : int) -> int:
	# attempt to remove all currently existing copies of this item with space
	var remainder = p_amount
	while(remainder != 0): # while there is still an amount left in remainder, search for a spot to delete this item
		var index = _find_item(item)
		if index == -1: # if there is no available item, then that means there are no more item spots to fill
			return remainder # so break this while loop
		remainder = storage[index]._remove_stack(remainder)
	# if by all odds all items were filled, then we return 0
	return 0

# returns 0 on success or a number depending on the remaining items that could not be added
func _add_item(item : Item) -> int:
	# while there are item spots to fill
	var remainder = item.amount
	if !storage_history.has(item.item_name):
		storage_history[item.item_name] = 0
	storage_history[item.item_name] += remainder
	while(remainder):
		remainder = _fill_item(item, remainder)
		if remainder == 0:
			# if at this point all items were miraculously filled, no need to keep going. return 0
			return 0
		var index = _find_empty_item() # find the first blank item, if none exists this will create one if possible
		if index == -1: # if there are no available empty items
			# simply return the amount that could not be filled
			storage_history[item.item_name] -= remainder
			return remainder
		# otherwise we can set this new item created to be the same type of item we're trying to fill, only with a stack of 0
		storage[index]._set_item(item)
		storage[index].amount = 0
		# and continue while loop
	# if against all odds every item was filled, we can return 0
	return 0

func _remove_item(item : Item) -> int:
	# while there are item spots to fill
	var remainder = item.amount
	if !storage_history.has(item.item_name):
		storage_history[item.item_name] = 0
	storage_history[item.item_name] -= remainder
	while(remainder):
		remainder = _unfill_item(item, remainder)
		if remainder == 0:
			# if at this point all items were miraculously filled, no need to keep going. return 0
			return 0
		var index = _find_item(item) # find the first blank item, if none exists this will create one if possible
		if index == -1: # if there are no available empty items
			# simply return the amount the could not be filled
			storage_history[item.item_name] = 0
			return remainder
		# otherwise we can set this new item created to be the same type of item we're trying to fill, only with a stack of 0
	# if against all odds every item was filled, we can return 0
	return 0

# finds the first item matching the provided item
# returns -1 if cannot be found
func _find_item(item : Item) -> int:
	for i in storage.size():
		if storage[i].item_name == item.item_name:
			# there is a matching item in inventory! return index
			return i
	return -1

# finds the first item matching the provided item and is not at maximum stack
func _find_available_item(item : Item) -> int:
	for i in storage.size():
		if storage[i].item_name == item.item_name and storage[i]._available(): # loop thru array, is there an item with a matching name and available space?
			# there is a matching item in inventory that has available space! return index
			return i
		else:
			# if not, keep looking
			continue
	# for loop failed return -1
	return -1

# finds a spot in the inventory array that is available to be filled in with another item. returns index to that spot
# returns -1 if cannot be found
func _find_empty_item() -> int:
		for i in storage.size(): # for every element in array, search for one that is empty or contains no items
			if storage[i].item_name == "blank_item": # this item has default name, therefore contains no item
				return i
			else:
				continue
		return -1 # no blank spot found

func _print_contents() -> void:
	for i in storage.size():
		print(storage[i].item_name + " x" + str(storage[i].amount))
