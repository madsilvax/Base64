extends CharacterBody2D
class_name Player

@export var speed = 100.0
@onready var camera_2d = $camera
@onready var animated_sprite_2d: AnimatedSprite2D = $anim
@export var camera_shake_intensity: float = 0.3
@onready var camera = $camera

var can_interact = true
var idle_direcao = ""
var can_be_played = true

signal interaction(dono)


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if direction and can_be_played:
		velocity = direction * speed
		if direction.x > 0: # Movendo direita
			animated_sprite_2d.play("walk_right")
			idle_direcao = "idle_right"
		elif direction.x < 0: # Movendo esquerda
			animated_sprite_2d.play("walk_left")
			idle_direcao = "idle_left"
		elif direction.y < 0: # Movendo para cima
			animated_sprite_2d.play("walk_up")
			idle_direcao = "idle_up"
		elif direction.y > 0: # Movendo para baixo
			animated_sprite_2d.play("walk_down")
			idle_direcao = "idle_down"
	else:
		velocity = Vector2.ZERO
		animated_sprite_2d.play(idle_direcao)
	
	move_and_slide()
	
	# Exemplo: detecta inimigos em um grupo "enemies" numa área 2D
	var enemies_nearby = $DetectionArea.get_overlappisng_bodies().filter(
		func(body): return body.is_in_group("enemies")
	)
		
	if enemies_nearby.size() > 0:
		camera.apply_shake(camera_shake_intensity * delta)
	else:
		camera.apply_shake(0)  # Para interromper gradualmente
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact and can_be_played:
		interaction.emit(self)
		print("emissao interaction")

# Corpo Interagivel Entrou
func _on_hurtbox_area_entered(area):
	pass

# Corpo Interagivel Saiu
func _on_hurtbox_area_exited(area):
	pass # Replace with function body.

func _on_hurtbox_body_entered(body):
	pass # Replace with function body.

func _on_hurtbox_body_exited(body):
	pass # Replace with function body.
