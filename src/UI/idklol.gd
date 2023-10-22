extends Node2D

tool


func _physics_process(delta):
	$Bee.rotation_degrees += 100.0 * delta
