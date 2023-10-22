extends Node


const amount : int = 1


func _ready() -> void:
	var size = PlayerInventory.inventory_size
	PlayerInventory._resize_inventory(size + amount)
	_remove_cookie()
	PlayerInventory._reset_inventory_ui()
	$ChompSound.play()


func _remove_cookie() -> void:
	var item = ItemLookup._get_as_item("Backpack Cookie")
	item.amount = 1
	PlayerInventory._remove_item(item)


func _on_audio_finish():
	self.queue_free()
