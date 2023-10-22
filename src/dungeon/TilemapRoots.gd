extends TileMap


export(float) var max_distance = 100.0


func _physics_process(_delta):
	if Input.is_action_just_pressed("use_item"):
		var player = PlayerInventory.player
		if player == null:
			return
		var tile : Vector2 = world_to_map(get_global_mouse_position())
		if get_cell(tile.x, tile.y) != -1 and _near_cell(tile, player):
			set_cell(tile.x, tile.y, -1)
			update_bitmask_area(tile)
			_tile_destroyed(tile, player)


func _near_cell(cell : Vector2, player : Node2D) -> bool:
	var cellpos = map_to_world(cell)
	cellpos.x += 24
	cellpos.y += 24
	return cell.distance_to(player.position) <= max_distance

func _tile_destroyed(tile : Vector2, player : Node2D) -> void:
	var item : Item 
	if randf() > 0.1:
		item = ItemLookup._get_as_item("Wood")
	else:
		item = ItemLookup._get_as_item("Lumber")
	item.amount = 1
	var pos : Vector2 = map_to_world(tile)
	pos.x += 24
	pos.y += 24
	player._spawn_dropped_item(item, pos)
