extends Control


func _str_has(text : String, what : String) -> bool:
	return text.count(what) > 0


# characters that cannot be contained in a world name
var restrictedchars : PoolStringArray = [
	"\\",
	"/",
	":",
	"*",
	"?",
	"\"",
	"<",
	">",
	"|"
]


func _on_create_world_clicked() -> void:
	var text = $Base/TopPanel/WorldNameInput.text
	var length = text.length()
	if length >= 1:
		for i in restrictedchars:
			if _str_has(text, i):
				$Base/TopPanel/ErrorMessage.show()
				return
		Game.call_deferred("_change_level", "res://scenes/Overworld.tscn")
		Game.world_name = $Base/TopPanel/WorldNameInput.text


func _close() -> void:
	$Base/TopPanel/WorldNameInput.text = ""
	$Base/TopPanel/ErrorMessage.hide()
	hide()
