extends Node2D

func _ready():
	var pause_menu = preload("res://screens/PauseMenu.tscn").instantiate()
	add_child(pause_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
