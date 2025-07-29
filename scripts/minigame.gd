extends Control

var virus = 10

signal minigame_over

func _process(delta: float) -> void:
	if virus == 0:
		emit_signal("minigame_over")
		queue_free()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_button_pressed() -> void:
	$screen/Button.queue_free()
	virus -= 1

func _on_button_2_pressed() -> void:
	$screen/Button2.queue_free()
	virus -= 1

func _on_button_3_pressed() -> void:
	$screen/Button3.queue_free()
	virus -= 1

func _on_button_4_pressed() -> void:
	$screen/Button4.queue_free()
	virus -= 1

func _on_button_5_pressed() -> void:
	$screen/Button5.queue_free()
	virus -= 1

func _on_button_6_pressed() -> void:
	$screen/Button6.queue_free()
	virus -= 1

func _on_button_7_pressed() -> void:
	$screen/Button7.queue_free()
	virus -= 1

func _on_button_8_pressed() -> void:
	$screen/Button8.queue_free()
	virus -= 1

func _on_button_9_pressed() -> void:
	$screen/Button9.queue_free()
	virus -= 1

func _on_button_10_pressed() -> void:
	$screen/Button10.queue_free()
	virus -= 1
