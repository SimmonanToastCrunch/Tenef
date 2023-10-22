extends StaticBody2D

export(int) var max_health = 30
var health : int = max_health
# this is how much damage needs to be done in order for a stone to be dropped
var checkpoint : int = 10
# how many checkpoints have been passed thus far
var checkpoints : int = 0

var particles : PackedScene = load("res://scenes/structures/Structure_Boulder_Particle.tscn")

var origin : Vector2 = Vector2.ZERO


func _ready():
	origin = position
	position.x += rand_range(-8.0, 8.0)
	position.y += rand_range(-8.0, 8.0)
	if randf() >= 0.5:
		$Silver.flip_h = true


func _on_hit(area):
	health -= area._get_damage()
	_spawn_particles()
	_handle_checkpoint()


func _spawn_particles() -> void:
	var instance = particles.instance()
	add_child(instance)


func _handle_checkpoint() -> void:
	# find the amount of missing health this boulder has
	var missing_health : int = max_health - health
	# find how many checkpoints have been passed with this amount of missing health
	var crossed_checkpoints : int = floor(missing_health / checkpoint)
	# subtract by the amount of checkpoints already passed
	# if a new checkpoint has been passed, spawn a stone
	if crossed_checkpoints - checkpoints != 0:
		checkpoints += 1
		if randf() > 0.5:
			_drop_silver()
		else:
			_drop_stone()
	if health <= 0:
		_drop_silver()
		BuildingInfo._remove_building(BuildingInfo._to_grid(origin))
		queue_free()


func _drop_silver() -> void:
	var item = ItemLookup._get_as_item("Silver Ore")
	item.amount = 1
	get_tree().call_group("player", "_spawn_dropped_item", item, position + $Silver.position) # center of boulder not top right corner


func _drop_stone() -> void:
	var item = ItemLookup._get_as_item("Stone")
	item.amount = 1
	get_tree().call_group("player", "_spawn_dropped_item", item, position)
