extends RigidBody2D


var item = Item.new()


var pickable : bool = false
var picked : bool = false


# default speed for this dropped item
var speed = 100


func _ready() -> void:
	$Anims.play("itemfloat")
	linear_velocity = Vector2(rand_range(-speed, speed), rand_range(speed, -speed))
	var direction = rand_range(-PI / 4, PI / 4)
	linear_velocity = linear_velocity.rotated(direction)
	_update()


func _update() -> void:
	$YSort/Icon.texture = item.item_texture
	$Amount.text = str(item.amount)


# when created, an item must wait 1s before it can be picked up. this code is called when that time is up
func _on_PickupTimer_timeout():
	pickable = true


func _on_Anims_animation_finished(_anim_name):
	$Anims.play("itemfloat")


func _on_contact(_area) -> void:
	if pickable:
		PlayerInventory.player._give_item(item)
		queue_free()


#func _on_body_contact(_body_rid, _body) -> void:
#	if pickable:
#		PlayerInventory.player._give_item(item)
#		queue_free()


func _physics_process(_delta):
	return
	rotation_degrees = 0.0
	if pickable and !picked:
		var arr = $Area2D.get_overlapping_areas()
		if arr.size() > 0:
			_on_contact(arr[0])
