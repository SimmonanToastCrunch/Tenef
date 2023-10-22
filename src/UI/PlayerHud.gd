extends CanvasLayer


func _blink() -> void:
	pass


func _stamina_changed(newstam) -> void:
	$StaminaWheel.value = newstam
	$StaminaWheel/Label.text = str(floor(($StaminaWheel.value / $StaminaWheel.max_value) * 100)) + "%"
	$StaminaWheel.update()


func _set_max_stam(newmaxstam) -> void:
	$StaminaWheel.max_value = newmaxstam
	$StaminaWheel/Label.text = str(floor(($StaminaWheel.value / $StaminaWheel.max_value) * 100)) + "%"
	$StaminaWheel.update()
