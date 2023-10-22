extends Node2D


var is_visible : bool
var do_delete : bool = false


var info : Item


func _update_info(new_info : Item) -> void:
	info = new_info
	_update()


func _update() -> void:
	$Name.modulate = info.quality
	$Background.modulate = info.quality
	var addendum = "Cursed "
	$Name.text = info.item_name
	$Description.text = info.item_description
	if info.cursed:
		$Name.text = addendum + $Name.text
		$Description.text += "\nWill be removed upon returning to the surface!"



func _fade(backwards : bool) -> void:
	if backwards:
		$Animations.play("fade", -1, -1.0)
	else:
		$Animations.play("fade")


func _process(_delta):
	position = get_global_mouse_position()


func _delete() -> void:
	do_delete = true
	_fade(false)

func _on_animation_finished(_anim_name):
	if do_delete:
		queue_free()
