extends Control


func _on_new_game_pressed() -> void:
	$NewGameUI.show()


func _on_load_game_pressed() -> void:
	$LoadGameUI.show()


func _on_settings_pressed() -> void:
	$SettingsMenuUI.show()
