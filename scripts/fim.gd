extends Control

@onready var final1 = $final1
@onready var final2 = $final2

func _ready():
	final1.play()

func _process(delta):
	pass

func _on_final_1_finished():
	final2.play()

func _on_final_2_finished():
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")
