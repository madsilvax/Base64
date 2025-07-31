extends CharacterBody2D

@onready var shoot_point: Marker2D = $shoot_point

@export var velocidade := 80.0
@export var distancia_perseguir := 200.0
@export var distancia_minima := 60.0
@export var projectile_scene: PackedScene

@onready var animation = $anim_kernel
@onready var shoot = $sfx_atirar
@onready var hitbox = $hitbox
@onready var music = $music_combat
@onready var death = $death

@export var vida_maxima := 10
var vida_atual: int

var morto := false
var player: Node2D = null
var pode_atirar := true
var em_fase2 := false

func _ready():
	vida_atual = vida_maxima
	animation.connect("animation_finished", Callable(self, "_on_anim_kernel_animation_finished"))

func _physics_process(delta):
	if morto:
		return
	
	if player == null:
		if animation.animation != "idle":
			animation.play("idle")
		velocity = Vector2.ZERO
		return

	var direcao = player.global_position - global_position
	var distancia = direcao.length()

	if distancia > distancia_perseguir:
		velocity = Vector2.ZERO
		if animation.animation != "idle":
			animation.play("idle")
	elif distancia < distancia_minima:
		velocity = Vector2.ZERO
		
		if animation.animation != "shoot":
			animation.play("shoot")
		atirar()
		return
	else:
		direcao = direcao.normalized()
		var velocidade_atual = velocidade * (1.5 if em_fase2 else 1.0)
		velocity = direcao * velocidade_atual
		move_and_slide()
		animation.flip_h = direcao.x < 0
		if animation.animation != "run":
			animation.play("run")


func atirar():
	if not pode_atirar or projectile_scene == null or player == null:
		return

	pode_atirar = false
	shoot.play()

	var dir_base = (player.global_position - shoot_point.global_position).normalized()
	var dirs = [dir_base]

	if em_fase2:
		# Spread 3 direções na fase 2
		var perpendicular = Vector2(-dir_base.y, dir_base.x) * 0.4
		dirs.append((dir_base + perpendicular).normalized())
		dirs.append((dir_base - perpendicular).normalized())

	for dir in dirs:
		var proj = projectile_scene.instantiate()
		proj.global_position = shoot_point.global_position
		proj.initialize(dir)

		# ⚠️ GARANTIR QUE PROJÉTIL DETECTA JOGADOR
		# Configura o grupo do projétil e conecta o sinal manualmente, se necessário
		if not proj.is_in_group("projetil"):
			proj.add_to_group("projetil")
		
		# Alternativa de conexão extra, se seu projétil não estiver reagindo:
		if proj.has_node("enemy_detection_area"):
			var area = proj.get_node("enemy_detection_area")
			if not area.is_connected("body_entered", Callable(proj, "_on_enemy_detection_area_body_entered")):
				area.connect("body_entered", Callable(proj, "_on_enemy_detection_area_body_entered"))

		get_tree().current_scene.add_child(proj)

	var distancia = global_position.distance_to(player.global_position)
	var intensidade = gauss_kernel(distancia, 100.0)

	var tempo_espera = lerp(1.2, 0.1, intensidade)
	if em_fase2:
		tempo_espera *= 0.7  # atira mais rápido na fase 2

	await get_tree().create_timer(tempo_espera).timeout
	pode_atirar = true


func _on_anim_kernel_animation_finished():
	if animation.animation == "shoot":
		if player != null:
			var distancia = player.global_position.distance_to(global_position)
			if distancia < distancia_perseguir:
				animation.play("run")
			else:
				animation.play("idle")
		else:
			animation.play("idle")


func gauss_kernel(dist: float, sigma: float) -> float:
	return exp(-pow(dist, 2) / (2.0 * pow(sigma, 2)))

func dano():
	vida_atual -= 1
	piscar_dano()

	if vida_atual <= 0 and not morto:
		morrer()

func piscar_dano():
	for i in range(2):
		animation.modulate = Color(1, 1, 1, 0.2)
		await get_tree().create_timer(0.1).timeout
		animation.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout 

func morrer():
	if morto:
		return
	morto = true
	print("MORRENDO COM VIDA:", vida_atual)

	velocity = Vector2.ZERO
	animation.speed_scale = 0.5
	animation.play("death")
	
	await get_tree().create_timer(2.5).timeout
	queue_free()

	music.stop()
	death.play()
	
	get_tree().change_scene_to_file("res://screens/fim.tscn")


func _on_hitbox_body_entered(body):
	if body.is_in_group("projetil"):
		body.queue_free()

func _on_player_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		atirar()
		music.play()

func _on_player_detection_area_body_exited(body):
	if body == player:
		player = null

func ativar_fase2():
	if em_fase2:
		return
	print("KERNEL AGORA ESTÁ EM FASE 2!")
	em_fase2 = true
	velocidade *= 1.5
