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

@export var vida_maxima := 3
var vida_atual: int


var morto := false
var player: Node2D = null
var pode_atirar := true

func _ready():
	vida_atual = vida_maxima


func _physics_process(delta):
	if morto:
		return  # Bloqueia tudo se já morreu
	
	if player == null:
		animation.play("idle")
		velocity = Vector2.ZERO
		return

	var direcao = player.global_position - global_position
	var distancia = direcao.length()

	if distancia > distancia_perseguir:
		velocity = Vector2.ZERO
		animation.play("idle")
	elif distancia < distancia_minima:
		velocity = Vector2.ZERO
		animation.play("shoot")
		atirar()
	else:
		direcao = direcao.normalized()
		velocity = direcao * velocidade
		move_and_slide()
		animation.flip_h = direcao.x < 0
		animation.play("run")


func atirar():
	if not pode_atirar or projectile_scene == null or player == null:
		return

	pode_atirar = false
	shoot.play()

	var proj = projectile_scene.instantiate()
	get_tree().current_scene.add_child(proj)

	proj.global_position = shoot_point.global_position
	proj.initialize((player.global_position - shoot_point.global_position).normalized())

	var distancia = global_position.distance_to(player.global_position)
	var intensidade = gauss_kernel(distancia, 100.0)
	var tempo_espera = lerp(1.5, 0.2, intensidade)  

	await get_tree().create_timer(tempo_espera).timeout
	pode_atirar = true

func gauss_kernel(dist: float, sigma: float) -> float:
	return exp(-pow(dist, 2) / (2.0 * pow(sigma, 2)))

func morrer():
	if morto:
		return
	morto = true
	print("MORRENDO COM VIDA:", vida_atual)
	
	velocity = Vector2.ZERO
	animation.play("death")
	await get_tree().create_timer(2).timeout
	queue_free()
	
	music.stop()
	death.play()
	
func _on_hitbox_body_entered(body):
	if body.is_in_group("projetil"):
		vida_atual -= 1
		print("Dano recebido! Vida restante:", vida_atual)
		if vida_atual <= 0:
			morrer()
		body.queue_free()

func _on_player_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		atirar()
		music.play()
		
func _on_player_detection_area_body_exited(body):
	if body == player:
		player = null
