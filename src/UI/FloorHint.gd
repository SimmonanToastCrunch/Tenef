extends CanvasLayer


export(int) var floor_number = 0
export(String) var dungeon = ""


func _ready() -> void:
	floor_number = Game.floor_number
	$FloorJargon/Floor.text = "Floor " + str(floor_number)
	$FloorJargon/Floor/Dungeon.text = "- " + dungeon + " -"
	$Anims.play("fade")


func _anim_over(_anim) -> void:
	queue_free()
