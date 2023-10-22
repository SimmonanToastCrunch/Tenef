extends RigidBody2D


export(int) var speed = 100
export(int) var amount = 1 


func _ready() -> void:
	$Anims.play("float")
	linear_velocity = Vector2(rand_range(-speed, speed), rand_range(speed, -speed))
	var direction = rand_range(-PI / 4, PI / 4)
	linear_velocity = linear_velocity.rotated(direction)


func _on_contact(_area) -> void:
	PlayerInventory._add_gold(amount)
	queue_free()


func _on_Anims_animation_finished(_anim_name) -> void:
	$Anims.play("float")


func _on_PickupTimer_timeout() -> void:
	pass


func _physics_process(_delta):
	rotation_degrees = 0.0
