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
	esta_correndo = Input.is_action_pressed("correr")
	
	var direcao: Vector2 = Input.get_vector("andar_esquerda", "andar_direita", "andar_cima", "andar_baixo")
	var velocidade_atual = velocidade * (multiplicador_corrida if esta_correndo else 1.0)
	
	if direcao and pode_se_mover:
		velocity = direcao * velocidade_atual
		
		if direcao.x > 0:
			sprite_animado.play("correr_direita" if esta_correndo else "andar_direita")
			animacao_parado = "parado_direita"
		elif direcao.x < 0:
			sprite_animado.play("correr_esquerda" if esta_correndo else "andar_esquerda")
			animacao_parado = "parado_esquerda"
		elif direcao.y < 0:
			sprite_animado.play("correr_cima" if esta_correndo else "andar_cima")
			animacao_parado = "parado_cima"
		elif direcao.y > 0:
			sprite_animado.play("correr_baixo" if esta_correndo else "andar_baixo")
			animacao_parado = "parado_baixo"
	else:
		velocity = Vector2.ZERO
		sprite_animado.play(animacao_parado)
	
	move_and_slide()
	
	# Verificação segura de inimigos próximos
	var inimigos_proximos = []
	if area_detecao:
		inimigos_proximos = area_detecao.get_overlapping_bodies().filter(
			func(corpo): return corpo.is_in_group("inimigos")
		)
	
	if inimigos_proximos.size() > 0:
		camera.aplicar_tremor(intensidade_tremer_camera * delta)
	else:
		camera.aplicar_tremor(0)
