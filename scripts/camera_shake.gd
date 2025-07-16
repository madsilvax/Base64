extends Camera2D

# Configurações do shake 
var shake_power: float = 0.0
var shake_decay: float = 0.5  # Velocidade que o shake diminui
var max_offset: Vector2 = Vector2(4, 4)  # Leve 
var noise = FastNoiseLite.new()  # Para shake mais orgânico

func _ready():
	noise.seed = randi()
	noise.frequency = 0.1

func _process(delta):
	if shake_power > 0:
		# Usa noise para um shake mais suave (ou randf() para algo mais caótico)
		var shake_offset = Vector2(
			noise.get_noise_1d(Time.get_ticks_msec() * 0.1) * max_offset.x * shake_power,
			noise.get_noise_1d(Time.get_ticks_msec() * 0.1 + 100) * max_offset.y * shake_power
		)
		offset = shake_offset  # Aplica o offset à câmera
		shake_power = max(0, shake_power - shake_decay * delta)
	else:
		offset = Vector2.ZERO  # Reseta quando o shake acaba

# Chamado quando o player está perto de inimigos
func apply_shake(intensity: float):
	shake_power = min(shake_power + intensity, 1.0)  # Limita a intensidade máxima
	
