extends Control

@onready var continue_button = $ContinueButton
@onready var quit_button = $QuitButton

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Conecta os botões
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	var paused = !get_tree().paused
	get_tree().paused = paused
	
	if paused:
		show()
		continue_button.grab_focus()  # Foca no botão de continuar
	else:
		hide()

func _on_continue_pressed():
	toggle_pause()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")  # Ajuste para sua cena de menu
