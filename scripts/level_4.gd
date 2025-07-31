extends Node2D

@onready var soundtrack_level0: AudioStreamPlayer2D = $"soundtrack"
@onready var timer_inicio: Timer = $"TimerInicio"
@onready var sussuros: AudioStreamPlayer2D = $"susurros"
@onready var timer_sussurros: Timer = $"TimerSussurros"

var player_minigame = false
var minigame_ready = true
var minigame_finished = false
var player_padlock = false
var padlock_finished = false

func _ready():
	var objetos = get_tree().get_nodes_in_group("objetos")
	for obj in objetos:
		if obj.has_node("AnimationPlayer"):
			var anim_player = obj.get_node("AnimationPlayer")
			var anims = anim_player.get_animation_list()
			for anim in anims:
				anim_player.play(anim)
	soundtrack_level0.play()
	timer_sussurros.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_timer_inicio_timeout():
	timer_sussurros.wait_time = randf_range(4.0, 8.0)
	timer_sussurros.start()

func _on_timer_sussurros_timeout():
	if randi() % 10 < 3 and not sussuros.playing:
		print("🔊 IA falando!")
		sussuros.play()
	else:
		print("IA não falou")

	timer_sussurros.wait_time = randf_range(4.0, 10.0)
	timer_sussurros.start()

func _on_kernel_tree_exited() -> void:
	get_tree().change_scene_to_file("res://screens/fim.tscn")
