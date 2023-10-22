extends KinematicBody2D


const knockback_weakness : float = 0.5
const friction : float = 0.95
export(int) var maxhp = 32
export(float) var hp = 32.0
export(int) var acceleration = 12
export(int) var movement_speed = 115
var leap_speed : int = 250
export(int) var attack_range = 120
var stunned : bool = false
var alive : bool = true
var crouched : bool = false
var leaping : bool = false
var can_attack : bool = true

# whether or not this enemy has detected the player
var alerted : bool = false
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var path : Array = []
var navigation : Navigation2D = null
var player : Node2D = null


onready var line = $Line2D


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	if get_tree().has_group("level_navigation"):
		navigation = get_tree().get_nodes_in_group("level_navigation")[0]
	if get_tree().has_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]


func _update_navigation() -> void:
	if player != null and navigation != null and line != null:
		path = navigation.get_simple_path(global_position, player.global_position, false)
		$Line2D.points = path


func _orient() -> void:
	# find next point
	if path.size() > 0:
		# set direction
		direction = global_position.direction_to(path[1])
		direction = direction.normalized()
		if global_position == path[0]:
			path.pop_front()


func _physics_process(_delta):
	if !stunned and !crouched and !leaping and alerted:
		if line != null:
			$Line2D.global_position = Vector2.ZERO
		_update_navigation()
		if alive:
			_orient()
			if direction.x < 0:
				$Sprite.flip_h = false
			else:
				$Sprite.flip_h = true
	#	if velocity.x != 0 and velocity.y != 0:
	#		velocity *= 0.9
		# yikes this looks awful
		# hopefully no one ever sees this...
		if alive:
			velocity += Vector2(acceleration * direction.x, acceleration * direction.y)
			velocity.x = clamp(velocity.x, -movement_speed, movement_speed)
			velocity.y = clamp(velocity.y, -movement_speed, movement_speed)
		else:
			velocity *= friction
		if global_position.distance_to(PlayerInventory.player.global_position) <= attack_range and $AttackCooldown.is_stopped() and alive:
			_crouch()
	if !alerted:
		velocity *= friction
	if crouched:
		velocity *= friction
	velocity = move_and_slide(velocity)


func _knockback(power : int, length : float) -> void:
	if !leaping:
		velocity = -position.direction_to(player.position)
		velocity *= power * knockback_weakness
		$KnockbackTimer.start(length * knockback_weakness)
		stunned = true


func _crouch() -> void:
	crouched = true
	velocity *= friction
	$Sprite.play("crouch")
	$AttackTimer.start()


func _attack() -> void:
	$Sprite.offset.y = 8
	$Sprite.play("leap")
	crouched = false
	leaping = true
	var dir = global_position.direction_to(player.global_position)
	velocity = dir * leap_speed
	$Sprite.flip_h = velocity.x >= 0.0
	$Anims.play("leap")
	$AttackLength.start(0.5)
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)


func _attack_over() -> void:
	velocity = Vector2.ZERO
	$Sprite.play("land")
	$DustParticles.emitting = true
	$DustParticles2.emitting = true
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$RecoveryLength.start()
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)


func _on_recover() -> void:
	crouched = false
	leaping = false
	can_attack = false
	$AttackCooldown.start()
	if alerted:
		$Sprite.play("run")
	else:
		$Sprite.play("idle")


func _on_cooldown_over() -> void:
	can_attack = true


func _on_boredom() -> void:
	if $AlertRange.get_overlapping_areas().size() == 0:
		if !crouched and !leaping:
			if alive:
				$Sprite.play("idle")
			else:
				$Sprite.play("dead")
			crouched = false
			$AttackTimer.stop()
			$AttackLength.stop()
		alerted = false


func _die() -> void:
	$Line2D.queue_free()
	line = null
	$Sprite.animation = "dead"
	$Sprite.self_modulate = Color(0.9, 0.9, 0.9, 1)
	$AttackTimer.stop()
	$AttackLength.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	alive = false
	can_attack = false
	crouched = false
	leaping = false
	$AlertRange/Range.set_deferred("disabled", true)
	_spawn_loot()


func _spawn_loot() -> void:
	var item : Item = ItemLookup._get_as_item("Bone Scraps")
	item.amount = 1
	player._spawn_dropped_item(item, position)
	
	var gold_amount : int = floor(rand_range(1.0, 3.0))
	for i in range(gold_amount):
		var instance = load("res://scenes/items/DroppedGold.tscn").instance()
		instance.position = position
		get_parent().call_deferred("add_child", instance)


func _create_damage_number(p_damage : int) -> void:
	var number_scene : PackedScene = load("res://scenes/enemies/DamageNumber.tscn")
	var instance = number_scene.instance()
	instance.position = position
	instance._set_text(str(p_damage))
	get_parent().add_child(instance)


func _on_hit(area) -> void:
	var damage = area._get_damage()
	hp -= damage
	_create_damage_number(damage)
	_knockback(area._get_knockback(), area._get_knockback_length())
	if hp <= 0:
		_die()


func _on_knockback_over() -> void:
	stunned = false


func _on_alert(_area) -> void:
	if !alerted:
		$AlertSound.play()
		$Alert.show()
		$Sprite.play("run")
		alerted = true


func _on_unalert(_area):
	$BoredomTimer.start()


func _on_sound_over() -> void:
	$Alert.hide()


