extends StaticBody2D


func _ready() -> void:
	$Sprite.flip_h = randf() <= 0.5
	$Sprite.offset.x = rand_range(-4.0, 4.0)
	$Sprite.offset.y = rand_range(-4.0, 4.0)
