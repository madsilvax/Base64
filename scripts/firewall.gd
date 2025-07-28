extends CharacterBody2D

@export var velocidade = 80.0
@export var distancia_perseguir = 200.0

@onready var anim = $AnimatedSprite2D  
@onready var player = null

@onready var death = $sfx_death
@onready var shoot = $sfx_atirar


func _ready():
	await get_tree().process_frame
	player = get_tree().get_current_scene().find_child("player", true, false)
	if player == null:
		print("⚠️ Player NÃO encontrado!")
	else:
		print("✅ Player encontrado: ", player.name)

func _physics_process(delta):
	if player == null:
		anim.play("idle")
		return
	
	var direcao = player.global_position - global_position
	var distancia = direcao.length()
	
	if distancia > distancia_perseguir:
		anim.play("idle")
		velocity = Vector2.ZERO
	else:
		direcao = direcao.normalized()
		velocity = direcao * velocidade
		move_and_slide()
		
		anim.flip_h = direcao.x < 0 
		anim.play("run")
		
		if distancia < 100:
			velocity = Vector2.ZERO
			anim.play("fast_shoot")  

func morrer():
	velocity = Vector2.ZERO
	anim.play("death")
	
