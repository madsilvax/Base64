extends Node2D

@onready var soundtrack_level0: AudioStreamPlayer2D = $"soundtrack"
@onready var timer_inicio: Timer = $"TimerInicio"
@onready var sussuros: AudioStreamPlayer2D = $"susurros"
@onready var timer_sussurros: Timer = $"TimerSussurros"
@onready var timer_spawn: Timer = $TimerSpawn

var player_minigame = false
var minigame_ready = true
var minigame_finished = false
var player_padlock = false
var padlock_finished = false

var tempo_passado := 0.0
var boss_fase2 := false

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
	timer_spawn.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	tempo_passado += delta
	
	if not boss_fase2 and tempo_passado >= 20.0:
		ativar_fase2()

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

func ativar_fase2():
	boss_fase2 = true
	print("⚠️ Boss entrou na FASE 2!")

	var boss = get_node_or_null("Ysort/Kernel") 
	if boss and boss.has_method("ativar_fase2"):
		boss.ativar_fase2()
