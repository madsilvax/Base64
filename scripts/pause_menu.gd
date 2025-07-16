extends Control

func _ready():
	hide()  # Esconde o menu no início
	process_mode = Node.PROCESS_MODE_ALWAYS  # Permite interação mesmo com o jogo pausado

func _input(event):
	if event.is_action_pressed("pause"):  # Ação definida em Project > Input Map
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		hide()
	else:
		get_tree().paused = true
		show()


func _on_continue_pressed():
	toggle_pause()
	
func _on_quit_pressed():
	get_tree().quit()
