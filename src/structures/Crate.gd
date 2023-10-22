extends StaticBody2D


var destroyed : bool = false


var sound : Array = [
	load("res://assets/sound/boxbreak1.ogg"),
	load("res://assets/sound/boxbreak2.ogg"),
	load("res://assets/sound/boxbreak3.ogg")
]


export(PoolStringArray) var loot_pool = [
	
]


func _ready() -> void:
	var rand = randi() % sound.size()
	$BreakSound.stream = sound[rand]


func _on_player_hit(_area) -> void:
	_destroy()


func _destroy() -> void:
	if !destroyed:
		var goldamount = floor(rand_range(3.0, 7.0))
		for i in range(goldamount + 1):
			_spawn_gold(global_position)
		$CollisionShape2D.queue_free()
		$Box.texture = load("res://assets/art/structures/structure_crate_broken.png")
		$BreakSound.play()
		$Anims.play("Fade")
		destroyed = true
		_enable_nav()


func _spawn_gold(p_position : Vector2) -> void:
	var instance = load("res://scenes/items/DroppedGold.tscn").instance()
	instance.global_position = p_position
	get_parent().call_deferred("add_child", instance)
	instance.position.x += 32
	instance.position.y += 24


func _enable_nav() -> void:
	if get_tree().has_group("tilemap_navigation"):
		var tilemap : TileMap = get_tree().get_nodes_in_group("tilemap_navigation")[0]
		var cell = tilemap.world_to_map(global_position)
		tilemap.set_cell(cell.x, cell.y, 0)
		tilemap.update_dirty_quadrants()


func _on_anim_end(anim_name):
	queue_free()
