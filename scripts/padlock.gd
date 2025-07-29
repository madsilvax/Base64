extends Control

var button1 = false
var button2 = false
var button3 = false
var button4 = false
var button5 = false
var button6 = false
var button7 = false
var button8 = false
var button9 = false

var password = [true, true, true, false, true, false, false, true, false]
var minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

signal padlock_over

func _process(delta: float) -> void:
	if minigame == password :
		emit_signal("padlock_over")
		queue_free()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_button_1_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button1 = true
	if toggled_on == false:
		button1 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

func _on_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button2 = true
	if toggled_on == false:
		button2 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

func _on_button_3_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button3 = true
	if toggled_on == false:
		button3 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

func _on_button_4_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button4 = true
	if toggled_on == false:
		button4 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

func _on_button_5_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button5 = true
	if toggled_on == false:
		button5 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

func _on_button_6_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button6 = true
	if toggled_on == false:
		button6 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

func _on_button_7_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button7 = true
	if toggled_on == false:
		button7 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

func _on_button_8_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button8 = true
	if toggled_on == false:
		button8 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]

func _on_button_9_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button9 = true
	if toggled_on == false:
		button9 = false
	minigame = [button1, button2, button3, button4, button5, button6, button7, button8, button9]


func _on_sair_pressed() -> void:
	$".".hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
