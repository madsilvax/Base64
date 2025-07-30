extends CharacterBody2D

@export var velocidade := 80.0
@export var distancia_perseguir := 200.0
@export var distancia_minima := 60.0  # Nova distância mínima para parar e atirar
@export var projectile_scene: PackedScene  # Cena exportada do projétil

@onready var anim = $AnimatedSprite2D
@onready var player = null

@onready var death = $sfx_death
@onready var shoot = $sfx_atirar
@onready var hitbox = $hitbox
@onready var shoot_point = $shoot_point  # Node2D/Marker2D onde o projétil nasce

var pode_atirar := true

func _ready():
	await get_tree().process_frame
	#player = get_tree().get_current_scene().find_child("player", true, false)

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
		velocity = Vector2.ZERO
		anim.play("idle")
	elif distancia < distancia_minima:
		velocity = Vector2.ZERO
		anim.play("fast_shoot")
		atirar()
	else:
		direcao = direcao.normalized()
		velocity = direcao * velocidade
		move_and_slide()
		anim.flip_h = direcao.x < 0
		anim.play("run")


func atirar():
	print("heloo shootingbboi")
	if not pode_atirar or projectile_scene == null:
		return

	pode_atirar = false
	shoot.play()

	var proj = projectile_scene.instantiate()
	get_tree().current_scene.add_child(proj)

	proj.global_position = shoot_point.global_position
	proj.direction = (player.global_position - global_position).normalized()

	await get_tree().create_timer(0.8).timeout  # Tempo entre tiros
	pode_atirar = true



func morrer():
	print("heloo dead boy shootingbboi")
	velocity = Vector2.ZERO
	death.play()
	anim.play("death")
	await anim.animation_finished
	
	queue_free()


func _on_hitbox_body_entered(body):
	if body.is_in_group("projetil"):
		print("🔥 Firewall atingido por projétil!")
		morrer()
		

func _on_player_detection_area_body_entered(body):
	if body.is_in_group("player"):
		var dir = body.global_position - global_position
		var dist = dir.length()
		dir = dir.normalized()
		anim.flip_h = dir.x < 0
		anim.play("run")


func _on_player_detection_area_body_exited(body):
	pass # Replace with function body.
