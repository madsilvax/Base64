extends Node2D

@onready var soundtrack_level0: AudioStreamPlayer2D = $"soundtrack"
@onready var timer_inicio: Timer = $"TimerInicio"
@onready var sussuros: AudioStreamPlayer2D = $"susurros"
@onready var timer_sussurros: Timer = $"TimerSussurros"

func _ready():
	soundtrack_level0.play()
	timer_sussurros.start()


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
