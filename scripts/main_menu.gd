extends Control

signal change_scene(scene: String)

@onready var menu_ost: AudioStreamPlayer2D = $"Menu ost"

var is_transitioning: bool = false  # Controla se já está em transição

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_ost.volume_db= -20
	menu_ost.play()
	
	var tween := create_tween()
	tween.tween_property(menu_ost, "volume_db", -5, 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_iniciar_pressed():
	if is_transitioning:
		return
	is_transitioning = true
	
	var fade_out_tween := create_tween()
	fade_out_tween.tween_property(menu_ost, "volume_db", -40.0, 2.0) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	
	# Emite o sinal para mudar para level_0.tscn
	change_scene.emit("res://scenes/level_0.tscn") 
	get_tree().change_scene_to_file("res://scenes/level_0.tscn")

	
func _on_sair_pressed() -> void:
	# Fade out da música antes de sair
	
	var fade_out_tween := create_tween()
	fade_out_tween.tween_property(menu_ost, "volume_db", -4.0, 1.0) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
	await fade_out_tween.finished
	get_tree().quit() 
	
