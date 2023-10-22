extends CanvasLayer


func _ready() -> void:
	$Anims.play("fade")


func _set_flip(flip) -> void:
	$Base/Sprite.flip_h = flip


func _button_pressed() -> void:
	$Anims.play("return")


func _anim_finish(anim_name) -> void:
	if anim_name == "return":
		PlayerInventory._remove_cursed_items()
		Game.call_deferred("_change_level", "res://scenes/Overworld.tscn")
