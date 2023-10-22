extends StaticBody2D


export(String) var item_name = "blank_item"
export(int) var price = 0
export(int) var amount = 1


var interactable : bool = true


func _ready() -> void:
	# rather than wasting resources on fetching items we can just access the texture directly
	# via the item lookup registry
	var itemtexture = load(ItemLookup.registry[item_name].texture)
	$Item.texture = itemtexture
	$Price/amount.text = str(price)
	$HUD.hide()


func _on_player_contact(area) -> void:
	if interactable:
		area.get_parent()._queue_interactable_object(self)
		$HUD.show()


func _on_player_uncontact(area) -> void:
	area.get_parent()._dequeue_interactable_object(self)
	$HUD.hide()


func _interact(player : Node) -> void:
	if PlayerInventory.gold >= price and amount > 0:
		PlayerInventory._remove_gold(price)
		var item = ItemLookup._get_as_item(item_name)
		item.amount = 1
		player._spawn_dropped_item(item, position + Vector2(32, 24))
		amount -= 1
		if amount == 0:
			$Item.self_modulate = Color(1.0, 1.0, 1.0, 0.5)
			$Price/amount.text = "--"
			$HUD.hide()
			interactable = false
