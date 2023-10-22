extends Node2D


const max_distance : int = 100


export(int) var health = 25
var can_use : bool = false


func _ready() -> void:
	_update_sprite()


func _update_sprite() -> void:
	if health <= 18:
		$Boards.animation = "boards_damaged"
	if health <= 8:
		$Boards.animation = "boards_broken"
	if health <= 0:
		$Boards.visible = false
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		can_use = true


func _on_hit(area):
	var damage = area._get_damage()
	health -= damage
	_update_sprite()


func _on_ButtonInteract_pressed():
	if can_use and global_position.distance_to(PlayerInventory.player.global_position) <= max_distance:
		Game._create_dungeon()
