extends KinematicBody2D


export(int) var roll_speed = 250
export(int) var movement_speed = 150 # speed duh
export(int) var acceleration = 25 # how much speed should increase per frame while an input is held
export(int)var friction = 80 # how much speed should decrease per frame while no input is held
var velocity : Vector2 = Vector2.ZERO # vector representing the direction of the player's movement
var roll_velocity : Vector2 = Vector2.ZERO
var stunned : bool = false
var alive : bool = true
var rolling : bool = false
var can_act : bool = true


var ghost_building : PackedScene = load("res://scenes/structures/Ghost_Building.tscn")


var interactable_queue = [
	
]


# ~ stats ~

# RPG stats
var health = 0 # max hp
var strength = 0 # base melee damage
var vitality = 0 # max stamina & stamina regen
var agility = 0 # speed & ranged damage??

# Game stats
func _calculate_hp(x) -> int:
	return int(ceil(sqrt(pow((x + 8), 3))))
var maxhp : int = 0
var hp : int = 0

#calculates max stamina at x'th level
func _calculate_stam(x) -> int:
	return ((x + 4) * 4)
#returns stamina regen rate at x'th level, int units per second
func _calculate_stamregen(x) -> float:
	return 5 + (x / 2)
var maxstam : int = 0
var stam : float = 0.0
var stamregen : float = 0.0


# check if a value is within a certain threshold
func within(value, minimum, maximum) -> bool:
	if value < minimum: # if value is less than minimum provided value, then it is not within
		return false
	elif value > maximum: # if value is higher than maximum provided value, then it is not within
		return false
	else:
		return true # value is not greater than or less than provided boundaries, then it must be within


func _ready():
	PlayerInventory._fetch_player()
	$InventoryUI._update_inventory_size()
	maxhp = _calculate_hp(health)
	hp = maxhp
	maxstam = _calculate_stam(vitality)
	stam = maxstam
	stamregen = _calculate_stamregen(vitality)
	$PlayerHud._set_max_stam(maxstam)
	$PlayerHud/Healthbar.max_value = maxhp
	$PlayerHud/Healthbar.value = hp


# gives an item to the player, and drops items the player cannot hold
func _give_item(item : Item) -> void:
	item.amount = PlayerInventory._add_item(item)
	if item.amount > 0:
		_spawn_dropped_item(item, position)
	$InventoryUI._update_inventory()


# removes an item from the player, and returns a remainder if there is one
func _remove_item(item : Item) -> int:
	var remainder = PlayerInventory._remove_item(item)
	$InventoryUI._update_inventory()
	return remainder


func _spawn_dropped_item(item : Item, p_position : Vector2) -> void:
	var instance = load("res://scenes/DroppedItem.tscn").instance()
	instance.item._set_item(item)
	instance.position = p_position
	get_parent().call_deferred("add_child", instance)


# spawn a ghost item that follows the cursor
func _spawn_ghost_item(item : Item) -> void:
	get_tree().call_group("ghost_building", "queue_free")
	if item.ghost_texture != null:
		var instance = ghost_building.instance()
		instance.texture = item.ghost_texture
		get_parent().call_deferred("add_child", instance)


func _can_act() -> bool:
	return can_act and !stunned and !rolling


func _process(_delta):
	if !alive:
		return
	#									#
	#		HORIZONTAL MOMVEMENT		#
	#									#
	if Input.is_action_pressed("move_right") and _can_act():
		$Sprite.flip_h = false
		$Sprite.play("walking")
		velocity.x += acceleration
		velocity.x = clamp(velocity.x, -(movement_speed - friction), movement_speed) # to prevent going too fast, also makes friction apply to turning
	elif Input.is_action_pressed("move_left") and _can_act():
		$Sprite.flip_h = true
		$Sprite.play("walking")
		velocity.x -= acceleration
		velocity.x = clamp(velocity.x, -movement_speed, movement_speed - friction)
	else:
		if velocity.x != 0 and !rolling: # be sure that velocity.x is not 0 so no divisions by zero
			# warning-ignore:narrowing_conversion
			var polarity : int = velocity.x / abs(velocity.x) # will always give us 1 or -1 depending on the pole of velocity.x
			velocity.x += friction * -polarity # bring velocity.x closer to center
			if within(velocity.x, -friction, friction):
				velocity.x = 0
	
	if Input.is_action_just_pressed("interact") and _can_act():
		if !interactable_queue.empty():
			if interactable_queue[0] != null:
				interactable_queue[0]._interact(self)
	
	if Input.is_action_just_released("scroll_up") and _can_act():
		PlayerInventory.selection_index = wrapi(PlayerInventory.selection_index + 1, 0, 5)
		_spawn_ghost_item(PlayerInventory.storage[PlayerInventory.selection_index])
	elif Input.is_action_just_released("scroll_down") and _can_act():
		PlayerInventory.selection_index = wrapi(PlayerInventory.selection_index - 1, 0, 5)
		_spawn_ghost_item(PlayerInventory.storage[PlayerInventory.selection_index])
	if Input.is_action_just_pressed("use_item") and !$InventoryUI.is_visible and _can_act():
		var item : Item = PlayerInventory.storage[PlayerInventory.selection_index]
		$Sprite.play("idle")
		if !item.item_name == "blank_item":
			item._use(self)
			can_act = false
	get_tree().call_group("itemboxes", "_update_selection")
	
	#									#
	#			VERTICAL MOVEMENT		#
	#									#
	if Input.is_action_pressed("move_down") and _can_act():
		$Sprite.play("walking")
		velocity.y += acceleration
		velocity.y = clamp(velocity.y, -(movement_speed - friction), movement_speed)
	elif Input.is_action_pressed("move_up") and _can_act():
		$Sprite.play("walking")
		velocity.y -= acceleration
		velocity.y = clamp(velocity.y, -movement_speed, movement_speed - friction)
	else:
		if velocity.y != 0 and !rolling:
			# warning-ignore:narrowing_conversion
			var polarity : int = velocity.y / abs(velocity.y) # will always give us 1 or -1 depending on the pole of velocity.x
			velocity.y += friction * -polarity # bring velocity.x closer to center
			if within(velocity.y, -friction, friction):
				velocity.y = 0
	
	
	if Input.is_action_just_pressed("roll"):
		_roll()
	
	if stunned:
		velocity *= 0.95
	
	# set to no animation if no movement at all
	if velocity.x == 0 and velocity.y == 0 and _can_act():
		$Sprite.play("idle")
	# weirdo hacky code becuase velocity.normalized() is broken for some reason
	if velocity.x != 0 and velocity.y != 0 and !rolling:
		velocity.x = clamp(velocity.x, -movement_speed * 0.707, movement_speed * 0.707)
		velocity.y =  clamp(velocity.y, -movement_speed * 0.707, movement_speed * 0.707)
	
	if rolling:
		move_and_slide(roll_velocity)
	else:
		velocity = move_and_slide(velocity)
	
	#									#
	#				DEBUG				#
	#									#
	
	if Input.is_action_pressed("debug_collide"):
		$WorldCollision.disabled = true
	else:
		$WorldCollision.disabled = false
	
	#									#
	#		MOVEMENT CODE OVER			#
	#									#

# set which interactable object is in range and can be interacted with
func _queue_interactable_object(node : Node) -> void:
	interactable_queue.push_back(node)


func _dequeue_interactable_object(node : Node) -> void:
	interactable_queue.pop_at(interactable_queue.find(node))


func _update_gold() -> void:
	$InventoryUI/Gold/Amount.text = str(PlayerInventory.gold)
	if !$Coin.playing:
		$Coin.play()


func _return_self() -> Node:
	return self


func _on_use_finish() -> void:
	can_act = true


# this is when the player should be able to act again
func _on_UseCooldownTimer_timeout():
	can_act = true


func _on_hit(area):
	var damage = area._get_damage()
	hp -= damage
	_knockback(area.get_parent().position, area._get_knockback(), area._get_knockback_length())
	$Anims.play("flash")
	$PlayerHud/Healthbar.value = hp
	if hp <= 0:
		_die()


func _knockback(pposition : Vector2, strength : float, length : float) -> void:
	stunned = true
	velocity = -(global_position.direction_to(pposition) * strength)
	$KnockbackTimer.start(length)


func _knockback_over() -> void:
	stunned = false


func _remove_stamina(amount : float) -> void:
	stam -= amount
	$StaminaRegen.stop()
	$StaminaDelay.start()
	$PlayerHud._stamina_changed(stam)


func _add_stamina(amount : float) -> void:
	stam += amount
	stam = clamp(stam, 0.0, maxstam)
	$PlayerHud._stamina_changed(stam)


func _on_stamina_delay_over() -> void:
	$StaminaRegen.start()


func _regen_stamina() -> void:
	if _can_act():
		_add_stamina(0.05)
		$PlayerHud._stamina_changed(stam)


func _die() -> void:
	# check to make sure the player hasn't died yet
	if alive:
		alive = false
		$InventoryUI._hide()
		$Sprite.play("dead")
		var gameover = load("res://scenes/ui/GameoverScreen.tscn").instance()
		call_deferred("add_child", gameover)
		gameover._set_flip($Sprite.flip_h)


func _roll() -> void:
	if stam >= 6:
		if Input.is_action_pressed("move_left"):
			roll_velocity.x = -1
		elif Input.is_action_pressed("move_right"):
			roll_velocity.x = 1
		else:
			roll_velocity.x = 0
		if Input.is_action_pressed("move_up"):
			roll_velocity.y = -1
		elif Input.is_action_pressed("move_down"):
			roll_velocity.y = 1
		else:
			roll_velocity.y = 0
		
		roll_velocity = velocity.normalized()
		roll_velocity *= roll_speed
		
		_remove_stamina(6)
		rolling = true
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		$Sprite.play("roll")
		$Anims.play("roll")

func _on_anim_over(anim_name):
	if anim_name == "roll":
		$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
		$Sprite.play("idle")
		rolling = false
