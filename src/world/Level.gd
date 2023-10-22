class_name Level
extends YSort


# whether or not the player can build here
export(bool) var buildable = false


func _ready() -> void:
	var item = ItemLookup._get_as_item("Stone Adze")
	item.amount = 1
	var player = PlayerInventory.player
	player._spawn_dropped_item(item, player.position)


