extends KinematicBody2D

export(int) var health = 20
export(int) var movement_speed = 40

var stunned : bool = false
var alive : bool = true

var velocity = Vector2.ZERO

var path : Array = [] # contains points that this entity must move to
var navigation : Navigation2D = null
var player : Node2D = null


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("player"):
		player = tree.get_nodes_in_group("player")[0]
	if tree.has_group("level_navigation"):
		navigation = tree.get_nodes_in_group("level_navigation")[0]


func _physics_process(_delta) -> void:
	if alive:
		$Line2D.global_position = Vector2.ZERO
		if player and !stunned:
			_generate_path()
			_navigate()
		_move()


func _navigate() -> void: # find the next point to travel to
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * movement_speed
		
		# if this point is reached, then remove it from the list
		if global_position == path[0]:
			path.pop_front()


func _generate_path() -> void:
	if player != null:
		path = navigation.get_simple_path(global_position, player.global_position, false)
		$Line2D.points = path


func _move() -> void:
	velocity = move_and_slide(velocity)


func _knockback(power : int, length : float) -> void:
	velocity = -position.direction_to(PlayerInventory.player.position)
	velocity *= power
	$KnockbackTimer.start(length)
	stunned = true


func _die() -> void:
	$Sprite.flip_v = true
	$Sprite.texture = load("res://assets/art/structures/structure_palmtree_coconut_gray.png")
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Line2D.queue_free()
	$Hurtbox.queue_free()
	set_process(false)



func _create_damage_number(p_damage : int) -> void:
	var number_scene : PackedScene = load("res://scenes/enemies/DamageNumber.tscn")
	var instance = number_scene.instance()
	instance.position = position
	instance._set_text(str(p_damage))
	get_parent().add_child(instance)


func _take_damage(p_damage : int, knockback_power : int, knockback_length : float) -> void:
	health -= p_damage
	_knockback(knockback_power, knockback_length)
	_create_damage_number(p_damage)
	if health <= 0:
		_die()


func _on_Hurtbox_area_entered(hitbox):
	_take_damage(hitbox._get_damage(), hitbox._get_knockback(), hitbox._get_knockback_length())


func _knockback_over():
	stunned = false
