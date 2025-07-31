extends CharacterBody2D
class_name Player

# Configurações de movimento
@export var velocidade = 100.0
@export var multiplicador_corrida = 1.8
@onready var camera = $camera
@onready var sprite_animado: AnimatedSprite2D = $anim
@export var intensidade_tremer_camera: float = 0.3
@onready var area_detecao: Area2D = $AreaDetecao
@onready var life_sprite: Sprite2D = $"UI player/UI layer/hud/life"
@export var projectile_scene: PackedScene
@onready var shoot_point = $ShootPoint
@onready var shoot_point_position_x = shoot_point.position.x

# Sons
@onready var recarregando_sfx: AudioStreamPlayer2D = $sfx_recarregar
@onready var atirando: AudioStreamPlayer2D = $sfx_atirar
@onready var sfx_noammo: AudioStreamPlayer2D = $sfx_noammo
@onready var death: AudioStreamPlayer2D = $sfx_death


# Variáveis de controle
var pode_interagir = true
var animacao_parado = ""
var pode_se_mover = true
var esta_correndo = false
var esta_atirando = false
var esta_recarregando = false

# Sistema de tiro
var pode_atirar = true
var municao = 10
var municao_maxima = 10
var municao_pente = 30
var pentes = 3
var morto := false

# Sistema de vida
@export var vida_maxima: int = 90
@export var vida_atual: int = vida_maxima
var invencivel: bool = false
@export var tempo_invencibilidade: float = 1.0

signal interagir(dono)

func _ready():
	if sprite_animado.sprite_frames.has_animation("atirando"):
		sprite_animado.sprite_frames.set_animation_loop("atirando", false)
	if sprite_animado.sprite_frames.has_animation("reload"):
		sprite_animado.sprite_frames.set_animation_loop("reload", false)

func _physics_process(delta: float) -> void:
	if morto:
		return 
	# Pausa movimentação durante ações
	if esta_atirando or esta_recarregando:
		velocity = Vector2.ZERO
		move_and_slide()  
		return
		
	# Verifica inputs de correr
	esta_correndo = (
		Input.is_action_pressed("correr_direita") or
		Input.is_action_pressed("correr_esquerda") or
		Input.is_action_pressed("correr_cima") or
		Input.is_action_pressed("correr_baixo")
	)
	
	# Movimentação normal
	var direcao: Vector2 = Input.get_vector("andar_esquerda", "andar_direita", "andar_cima", "andar_baixo")
	var velocidade_atual = velocidade * (multiplicador_corrida if esta_correndo else 1.0)

	if direcao != Vector2.ZERO and pode_se_mover:
		velocity = direcao.normalized() * velocidade_atual
		sprite_animado.play("run")
		
		if direcao.x < 0:
			sprite_animado.flip_h = true
			shoot_point.position.x = -shoot_point_position_x
		elif direcao.x > 0:
			sprite_animado.flip_h = false
			shoot_point.position.x = shoot_point_position_x
	else:
		velocity = Vector2.ZERO
		sprite_animado.play("padrao_baixo")
	
	move_and_slide()
	
	# Controles de tiro e recarga
	if Input.is_action_just_pressed("atirar") and not esta_atirando and not esta_recarregando and municao > 0:
		shoot()
		
	if Input.is_action_just_pressed("recarregar") and not esta_recarregando and not esta_atirando and municao < municao_maxima and municao_pente > 0:
		reload()
	
	update_life()
func dano():
	vida_atual -= 10
	
func shoot():
	if municao <= 0:
		sfx_noammo.play()
		return

	esta_atirando = true
	sprite_animado.play("atirando")
	atirando.play()
	municao -= 1

	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = shoot_point.global_position

	# Define direção com base na orientação do player (você pode mudar isso para mouse, se quiser)
	var dir = Vector2.RIGHT
	if not sprite_animado.flip_h:
		dir = Vector2.RIGHT
	else:
		dir = Vector2.LEFT
	projectile.initialize(dir)

	await sprite_animado.animation_finished
	esta_atirando = false

	if velocity == Vector2.ZERO:
		sprite_animado.play("padrao_baixo")
	else:
		sprite_animado.play("run")


func reload():
	if esta_recarregando:
		return
	esta_recarregando = true
	
	# Toca o som de recarregar imediatamente
	recarregando_sfx.play()
	sprite_animado.play("reload")
	
	# Aguarda um tempo fixo para evitar delay (ajuste 0.5 para o valor desejado)
	await get_tree().create_timer(0.5).timeout
	
	# Calcula quantas balas recarregar
	var balas_para_recarregar = min(municao_maxima - municao, municao_pente)
	municao += balas_para_recarregar
	municao_pente -= balas_para_recarregar
	
	esta_recarregando = false
	
	# Volta para animação padrão
	if velocity == Vector2.ZERO:
		sprite_animado.play("padrao_baixo")
	else:
		sprite_animado.play("run")

func update_life():
	if vida_atual == 90:
		life_sprite.set_frame(10)
	if vida_atual == 80:
		life_sprite.set_frame(9)
	if vida_atual == 70:
		life_sprite.set_frame(8)
	if vida_atual == 60:
		life_sprite.set_frame(7)
	if vida_atual == 50:
		life_sprite.set_frame(6)
	if vida_atual == 40:
		life_sprite.set_frame(5)
	if vida_atual == 30:
		life_sprite.set_frame(4)
	if vida_atual == 20:
		life_sprite.set_frame(3)
	if vida_atual == 10:
		life_sprite.set_frame(2)
	if vida_atual == 0:
		life_sprite.set_frame(1)
		
		morrer()

func _exit_tree():
	# Para todos os sons ao sair da cena para evitar que continuem tocando
	recarregando_sfx.stop()
	atirando.stop()
	sfx_noammo.stop()
	
func morrer():
	if morto:
		return
	morto = true
	print("morri")
	velocity = Vector2.ZERO
	
	var cameras = get_tree().get_nodes_in_group("camera")
	if cameras.size() > 0:
		cameras[0].trigger_shake()  
	
	sprite_animado.play("morte")
	death.play()
	await get_tree().create_timer(2).timeout
	get_tree().reload_current_scene()
