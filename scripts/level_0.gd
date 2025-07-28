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
	$Ysort/player/minigame.connect("minigame_over", open_door)
	$Ysort/player/padlock.connect("padlock_over", open_door)
	soundtrack_level0.play()
	timer_sussurros.start()

func _input(event):
	if Input.is_action_just_pressed("interagir"):
		if player_minigame == true:
			get_tree().paused = true
			$Ysort/player/minigame.show()
		if player_padlock == true:
			get_tree().paused = true
			$Ysort/player/padlock.show()

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

func _on_screen_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_minigame = true

func _on_screen_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_minigame = false

func open_door():
	get_tree().paused = false
	$Ysort/Door/block.queue_free()
	$Ysort/player/minigame.queue_free()
	$Ysort/player/padlock.queue_free()
	$Ysort/Screen/screen_area.queue_free()
	$Ysort/Door/door_area.queue_free()
	$Ysort/Screen.play("off")
	$Ysort/Door.play("open")

func _on_door_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_padlock = true

func _on_door_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_padlock = false

func _on_end_body_entered(body: Node2D) -> void:
	pass #trocar cena / fim do jogo
