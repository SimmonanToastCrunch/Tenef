class_name Hitbox
extends Area2D


signal damage_taken(p_damage)


const Damage = preload("res://src/Damage.gd").Damage


# this script should be attached to every hitbox object
export(int) var damage_min
export(int) var damage_max
export(int) var knockback_power
export(float) var knockback_length
# damage object
var damage : Damage

func _ready():
	# thank dynamic casting!
	# turn our damage variable into a damage object
	damage = Damage.new(damage_min, damage_max)

func _get_damage() -> int:
	var return_val = damage._damage()
	emit_signal("damage_taken", return_val)
	return return_val


func _get_knockback() -> int:
	return knockback_power


func _get_knockback_length() -> float:
	return knockback_length
