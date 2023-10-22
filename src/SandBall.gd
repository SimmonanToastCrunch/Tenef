extends RigidBody2D


var damage : float = 1.0
var damage_type : String = "normal"
var movement_speed : int = 250

func _ready():
	linear_velocity.x = get_local_mouse_position().normalized().x * movement_speed
	linear_velocity.y = get_local_mouse_position().normalized().y * movement_speed

func _physics_process(_delta):
	$Sprite.rotation_degrees += 9

func _on_LifetimeTimer_timeout():
	$CollisionShape2D.disabled = true
	$Sprite.texture = load("res://assets/art/item_blank.png")
	$Sprite/Particles2D.emitting = false
	$Sprite/DeathParticles.emitting = true


func _on_MasterTimer_timeout():
	queue_free()
