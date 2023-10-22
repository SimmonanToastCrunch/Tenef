extends Node2D


func _on_press() -> void:
	var item : Item = ItemLookup._get_as_item($ItemName.text)
	item.amount = int($Amount.text)
	PlayerInventory.player._give_item(item)
