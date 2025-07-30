extends Control

@onready var sfx_alarme : AudioStreamPlayer2D = $"alarme2"
@onready var fade_animation =  $FadeAnimation
@onready var transition_timer = $Timer_transition

signal change_scene(scene: String)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	fade_animation.color = Color(0, 0, 0, 1) 
	fade_in()  

func fade_in():
	var tween = create_tween()
	tween.tween_property(fade_animation, "color:a", 0.0, 1.0)  

func fade_out():
	var tween = create_tween()
	tween.tween_property(fade_animation, "color:a", 1.0, 1.0)  
	await tween.finished
	change_scene.emit("res://scenes/level_1.tscn")
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_timer_timeout():
	fade_out()  

func _on_timer_alarme_timeout():
	sfx_alarme.play()
