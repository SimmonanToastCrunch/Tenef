extends StaticBody2D


signal exit(structure)


var grid_postion = Vector2.ZERO


func _ready() -> void:
	yield()
	grid_postion = BuildingInfo._to_grid(global_position)
	_shift_position()


func _shift_position() -> void:
	$Sprite.position.x += rand_range(-8.0, 8.0)
	$Sprite.position.y += rand_range(-8.0, 8.0)
	if rand_range(0.0, 1.0) > 0.5:
		$Sprite.flip_h = true


func _on_PlayerCollisionRange_area_entered(area) -> void:
	$SpriteKey.show()
	area.get_parent()._queue_interactable_object(self)


func _interact(node : Node) -> void:
	var item = ItemLookup._get_as_item("Wood")
	item.amount = 1
	position += Vector2(24, 24)
	node._spawn_dropped_item(item, position)
	BuildingInfo._remove_building(BuildingInfo._to_grid(position))
	
	queue_free()


func _on_PlayerCollisionRange_area_exited(area) -> void:
	area.get_parent()._dequeue_interactable_object(self)
	$SpriteKey.hide()


func _exit_tree() -> void:
	AI._set_navigation_tile(grid_postion.x, grid_postion.y, 0)
	emit_signal("exit", self)
