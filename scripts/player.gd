extends CharacterBody2D
class_name Player

# Configurações de movimento
@export var velocidade = 100.0
@export var multiplicador_corrida = 1.8  # Velocidade ao correr
@onready var camera = $camera
@onready var sprite_animado: AnimatedSprite2D = $anim
@export var intensidade_tremer_camera: float = 0.3
@onready var recarregando_sfx: AudioStreamPlayer2D = $sfx_recarregar
@onready var atirando: AudioStreamPlayer2D = $sfx_atirar

#UI
#@onready var barra_vida: TextureProgressBar = $UI/BarraVida
#@onready var barra_vida: TextureProgressBar = $UI/rostinho
#@onready var barra_vida: TextureProgressBar = $UI/inventario
#@onready var barra_vida: TextureProgressBar = $UI/inventario


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
@onready var dano_sfx: AudioStreamPlayer2D = $sfx_dano  # Adicione um AudioStreamPlayer2D para som de dano

signal interagir(dono)  # Sinal para interação com objetos

func _physics_process(delta: float) -> void:
	# Controle de corrida (Shift)
	esta_correndo = Input.is_action_pressed("correr")
	
	var direcao: Vector2 = Input.get_vector("andar_esquerda", "andar_direita", "andar_cima", "andar_baixo")
	var velocidade_atual = velocidade * (multiplicador_corrida if esta_correndo else 1.0)
	
	# Movimento e animações
	if direcao and pode_se_mover:
		velocity = direcao * velocidade_atual
		
		if direcao.x > 0:  # Direita
			sprite_animado.play("correr_direita" if esta_correndo else "andar_direita")
			animacao_parado = "parado_direita"
		elif direcao.x < 0:  # Esquerda
			sprite_animado.play("correr_esquerda" if esta_correndo else "andar_esquerda")
			animacao_parado = "parado_esquerda"
		elif direcao.y < 0:  # Cima
			sprite_animado.play("correr_cima" if esta_correndo else "andar_cima")
			animacao_parado = "parado_cima"
		elif direcao.y > 0:  # Baixo
			sprite_animado.play("correr_baixo" if esta_correndo else "andar_baixo")
			animacao_parado = "parado_baixo"
	else:
		velocity = Vector2.ZERO
		sprite_animado.play(animacao_parado)
	
	move_and_slide()
	
	# Tremer câmera perto de inimigos
	var inimigos_proximos = $AreaDetecao.get_overlapping_bodies().filter(
		func(corpo): return corpo.is_in_group("inimigos")
	)
	
	if inimigos_proximos.size() > 0:
		camera.aplicar_tremor(intensidade_tremer_camera * delta)
	else:
		camera.aplicar_tremor(0)

func _process(delta: float) -> void:
	# Interação
	if Input.is_action_just_pressed("interagir") and pode_interagir and pode_se_mover:
		interagir.emit(self)
		print("Interação realizada")
	
	# Tiro
	if Input.is_action_just_pressed("atirar") and pode_atirar and municao > 0:
		atirar()
	
	# Recarregar
	if Input.is_action_just_pressed("recarregar"):
		recarregar()

func atirar():
	#if cena_bala and pode_atirar:
		#var bala = cena_bala.instantiate()
		#bala.position = global_position
		#bala.direction = (get_global_mouse_position() - global_position).normalized()
		#get_parent().add_child(bala)
		#municao -= 1
		#pode_atirar = false
		#await get_tree().create_timer(0.2).timeout  # Tempo entre tiros
		#pode_atirar = true
		
		atirando.play()
		
func receber_dano(quantidade: int):
	if invencivel:
		return
		
	vida_atual -= quantidade
	dano_sfx.play()
	
	# Ativa invencibilidade temporária
	invencivel = true
	await get_tree().create_timer(tempo_invencibilidade).timeout
	invencivel = false
	
	# Piscar o sprite para feedback visual
	for i in 3:
		sprite_animado.modulate.a = 0.5
		await get_tree().create_timer(0.1).timeout
		sprite_animado.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout
	
	verificar_morte()

func verificar_morte():
	if vida_atual <= 0:
		morrer()

func morrer():
	print("Jogador morreu!")
	pode_se_mover = false
	sprite_animado.play("morrer")
	await sprite_animado.animation_finished
	# Ou reiniciar a cena ou mostrar tela de game over
	get_tree().reload_current_scene()

func recarregar():
	sprite_animado.play("")
	await sprite_animado.animation_finished
	municao = municao_maxima
	
	if pentes > 0:
		pentes -= 1
		municao = municao_pente
		
	recarregando_sfx.play()
	
	

func _input(event):
	if event.is_action_just_pressed("pausar"):
		get_tree().paused = not get_tree().paused
		# Mostrar/esconder menu de pause aqui

# Funções de área (colisões)
func _on_area_dano_area_entered(area): pass
func _on_area_dano_area_exited(area): pass
func _on_area_dano_body_entered(corpo): pass
func _on_area_dano_body_exited(corpo): pass
