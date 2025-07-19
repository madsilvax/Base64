extends CharacterBody2D
class_name Player

# Configurações de movimento
@export var velocidade = 100.0
@export var multiplicador_corrida = 1.8
@onready var camera = $camera
@onready var sprite_animado: AnimatedSprite2D = $anim
@export var intensidade_tremer_camera: float = 0.3
@onready var recarregando_sfx: AudioStreamPlayer2D = $sfx_recarregar
@onready var atirando: AudioStreamPlayer2D = $sfx_atirar
@onready var area_detecao: Area2D = $AreaDetecao
@onready var dano_sfx: AudioStreamPlayer2D = $sfx_dano

# Variáveis de controle
var pode_interagir = true
var animacao_parado = ""
var pode_se_mover = true
var esta_correndo = false

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

func _physics_process(delta: float) -> void:
	# Verifica todos os inputs de correr
	esta_correndo = (
		Input.is_action_pressed("correr_direita")
		or Input.is_action_pressed("correr_esquerda")
		or Input.is_action_pressed("correr_cima")
		or Input.is_action_pressed("correr_baixo")
	)
	
	# Pega direção baseada nos inputs
	var direcao: Vector2 = Input.get_vector("andar_esquerda", "andar_direita", "andar_cima", "andar_baixo")
	var velocidade_atual = velocidade * (multiplicador_corrida if esta_correndo else 1.0)

	if direcao != Vector2.ZERO and pode_se_mover:
		velocity = direcao.normalized() * velocidade_atual
		
		# Sempre toca a mesma animação
		sprite_animado.play("run") 

		# Inverte horizontalmente se for para a esquerda
		if direcao.x < 0:
			sprite_animado.flip_h = true
		elif direcao.x > 0:
			sprite_animado.flip_h = false

	else:
		velocity = Vector2.ZERO
		# Para quando parado 
		sprite_animado.play("padrao_baixo")
		
	move_and_slide()
	
	## Verificação segura de inimigos próximos
	#var inimigos_proximos = []
	#if area_detecao:
		#inimigos_proximos = area_detecao.get_overlapping_bodies().filter(
			#func(corpo): return corpo.is_in_group("inimigos")
		#)
	#
	#if inimigos_proximos.size() > 0:
		#camera.aplicar_tremor(intensidade_tremer_camera * delta)
	#else:
		#camera.aplicar_tremor(0)
