extends Node2D

@onready var soundtrack_level0: AudioStreamPlayer2D = $"soundtrack"


func _ready():
	soundtrack_level0.play()
