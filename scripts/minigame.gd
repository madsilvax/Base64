extends Node2D

var virus = 10

func _process(delta: float) -> void:
	if virus == 0:
		queue_free()

func _on_button_pressed() -> void:
	$Control/screen/Button.queue_free()
	virus -= 1

func _on_button_2_pressed() -> void:
	$Control/screen/Button2.queue_free()
	virus -= 1

func _on_button_3_pressed() -> void:
	$Control/screen/Button3.queue_free()
	virus -= 1

func _on_button_4_pressed() -> void:
	$Control/screen/Button4.queue_free()
	virus -= 1

func _on_button_5_pressed() -> void:
	$Control/screen/Button5.queue_free()
	virus -= 1

func _on_button_6_pressed() -> void:
	$Control/screen/Button6.queue_free()
	virus -= 1

func _on_button_7_pressed() -> void:
	$Control/screen/Button7.queue_free()
	virus -= 1

func _on_button_8_pressed() -> void:
	$Control/screen/Button8.queue_free()
	virus -= 1

func _on_button_9_pressed() -> void:
	$Control/screen/Button9.queue_free()
	virus -= 1

func _on_button_10_pressed() -> void:
	$Control/screen/Button10.queue_free()
	virus -= 1
