extends Node2D


var parent : Node2D = null
var maxhp : int = 0
var hp : float = 0.0



func _ready() -> void:
	parent = get_parent()
	


func _physics_process(_delta):
	maxhp = parent.maxhp
	hp = parent.hp
	$Progress.max_value = maxhp
	$Progress.value = hp
	if hp <= 0:
		queue_free()
