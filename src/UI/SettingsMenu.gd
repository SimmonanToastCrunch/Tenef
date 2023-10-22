extends Control


var can_quit : bool = false


func _on_back_pressed() -> void:
	hide()
	_hide_quit()


func _show_quit() -> void:
	$MainPanel/QuitButton.show()


func _hide_quit() -> void:
	can_quit = false
	$MainPanel/QuitButton.text = "Save & Quit"
	$MainPanel/QuitButton/Safety.hide()


func _on_quit() -> void:
	if can_quit:
		get_tree().quit()
	else:
		$MainPanel/QuitButton/Safety.show()
		$MainPanel/QuitButton.text = "Yes!"
		can_quit = true
