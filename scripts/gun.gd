extends CharacterBody2D

@export var speed := 2000.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	# O sprite pode ter uma animação de voo, se quiser
	$AnimatedSprite2D.play()
	add_to_group("projetil")

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		queue_free()

func _on_life_timer_timeout():
	queue_free()
