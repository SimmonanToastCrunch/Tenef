extends Node2D

export(int) var direction : int = 1

export(int) var max_vel = 5
export(int) var max_ang = 1

export(int) var max_lumber_amount = 2
export(int) var min_lumber_amount = 1

export(int) var max_wood_amount = 3
export(int) var min_wood_amount = 1

func _ready() -> void:
	if rand_range(-1.0, 1.0) < 0:
		direction = -1
	$TreeBody.bounce = 0.4
	$TreeBody.linear_velocity.x = randi() % max_vel + 1 * direction
	$TreeBody.angular_velocity = randi() % max_ang + 1 * direction

func _on_timeout() -> void:
	var wood = ItemLookup._get_as_item("Wood")
	wood.amount = round(rand_range(min_wood_amount, max_wood_amount))
	get_tree().call_group("player", "_spawn_dropped_item", wood, get_parent().position + Vector2(72 * direction, 36))
	queue_free()
