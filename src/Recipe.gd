class Recipe extends Node:
	
	var result : String
	var result_amount : int
	
	var items_needed = [
	]
	
	
	func _init(p_result : String, p_result_amount : int, p_items_needed : Dictionary):
		result = p_result
		result_amount = p_result_amount
		items_needed.push_back(p_items_needed)
		add_to_group("recipe")
	
	
	func _can_craft(inventory : Inventory) -> bool:
		# loop through all items that are needed
		var keys = items_needed[0].keys()
		for i in items_needed[0].size():
			# if the total items is not greater than or equal to the amount needed in items_needed...
			if inventory.storage_history.has(keys[i]):
				if !inventory.storage_history[keys[i]] >= items_needed[0][keys[i]]:
					# return false.
					return false
					# otherwise, keep going until for loop is over. then return true
			else:
				return false
		return true
	
	
	func _craft(src_inventory : Inventory) -> void:
		var keys = items_needed[0].keys()
		if _can_craft(src_inventory):
			# for each item needed
			for i in items_needed[0].size():
				# remove the amount required
				var item = ItemLookup._get_as_item(keys[i])
				item.amount = items_needed[0][keys[i]]
				# remove the correct amount of items
				# no checks should be necessary bc we've already checked
				# warning-ignore:return_value_discarded
				src_inventory._remove_item(item)
			var crafted_item = ItemLookup._get_as_item(result)
			crafted_item.amount = result_amount
			PlayerInventory.player._give_item(crafted_item)
	
	
	
	
