extends Node2D

func _ready():
	var pause_menu = preload("res://screens/PauseMenu.tscn").instantiate()
	add_child(pause_menu)
	$Camera2D.make_current()
