extends CharacterBody2D
class_name Player

# Configurações de movimento
@export var velocidade = 100.0
@export var multiplicador_corrida = 1.8
@onready var camera = $camera
@onready var sprite_animado: AnimatedSprite2D = $anim
@export var intensidade_tremer_camera: float = 0.3
@onready var area_detecao: Area2D = $AreaDetecao

# Sons
@onready var recarregando_sfx: AudioStreamPlayer2D = $sfx_recarregar
@onready var atirando: AudioStreamPlayer2D = $sfx_atirar
@onready var dano_sfx: AudioStreamPlayer2D = $sfx_dano

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

# Sistema de vida
@export var vida_maxima: int = 100
var vida_atual: int = vida_maxima
var invencivel: bool = false
@export var tempo_invencibilidade: float = 1.0

signal interagir(dono)

func _ready():
	if sprite_animado.sprite_frames.has_animation("atirando"):
		sprite_animado.sprite_frames.set_animation_loop("atirando", false)
	if sprite_animado.sprite_frames.has_animation("reload"):
		sprite_animado.sprite_frames.set_animation_loop("reload", false)

func _physics_process(delta: float) -> void:
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
		elif direcao.x > 0:
			sprite_animado.flip_h = false
	else:
		velocity = Vector2.ZERO
		sprite_animado.play("padrao_baixo")
	
	move_and_slide()
	
	# Controles de tiro e recarga
	if Input.is_action_just_pressed("atirar") and not esta_atirando and not esta_recarregando and municao > 0:
		shoot()
		
	if Input.is_action_just_pressed("recarregar") and not esta_recarregando and not esta_atirando and municao < municao_maxima and municao_pente > 0:
		reload()

func shoot():
	esta_atirando = true
	sprite_animado.play("atirando")
	atirando.play()
	municao -= 1
	
	# Espera a animação terminar
	await sprite_animado.animation_finished
	esta_atirando = false
	
	# Volta para animação padrão
	if velocity == Vector2.ZERO:
		sprite_animado.play("padrao_baixo")
	else:
		sprite_animado.play("run")

func reload():
	esta_recarregando = true
	sprite_animado.play("reload")
	recarregando_sfx.play()
	
	# Espera a animação terminar
	await sprite_animado.animation_finished
	
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
