extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		$"UI layer/pause".show()
		get_tree().paused = true
		$"UI layer/pause/AnimationPlayer".play("blur")

func _on_continue_pressed() -> void:
	$"UI layer/pause".hide()
	get_tree().paused = false
	$"UI layer/pause/AnimationPlayer".play_backwards("blur")

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")
