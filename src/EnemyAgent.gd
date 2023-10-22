extends KinematicBody2D

export(int) var movement_speed = 40
var velocity = Vector2.ZERO
var destination = Vector2.ZERO

var level_navigation : Navigation2D = null
var player : Node2D = null


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("player"):
		player = tree.get_nodes_in_group("player")[0]
		$NavigationAgent2D.set_target_location(player.position)


func _physics_process(_delta) -> void:
	$Line2D.global_position = Vector2.ZERO
	if player:
		_get_destination()
		_navigate()
	_move()


func _navigate() -> void: # find the next point to travel to
	velocity = global_position.direction_to(destination) * movement_speed


func _get_destination() -> void:
	if player != null:
		$NavigationAgent2D.set_target_location(player.position)
		destination = $NavigationAgent2D.get_next_location()
		$Line2D.points = [
			self.position,
			destination
		]


func _move() -> void:
	velocity = move_and_slide(velocity)
