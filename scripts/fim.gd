extends Control

@onready var final1 = $final1
@onready var final2 = $final2
@onready var final3 = $ultimo
@onready var fade: ColorRect = $fade

@onready var label: Label = $Label
var texto_completo = "E é este o jeito que os computadores falam entre si"
var velocidade_digito = 0.03 #segundos entre tela

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Estilo laranja terminal antigo (âmbar)
	label.add_theme_color_override("font_color", Color(1.0, 0.55, 0.0))  # laranja âmbar
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 1)

	label.add_theme_color_override("font_color_shadow", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)

	self.add_theme_color_override("panel", Color(0, 0, 0))  # fundo preto

	final1.play()


func _process(delta):
	pass

func _on_final_1_finished():
	final2.play()
	mostrar_texto_digitando(texto_completo)


func _on_final_2_finished():
	final3.play()

func _on_final_3_finished():
	var tween = create_tween()

	tween.tween_property(fade, "modulate:a", 1.0, 1.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")


func mostrar_texto_digitando(texto: String) -> void:
	label.text = ""
	for i in texto.length():
		label.text += texto[i]
		await get_tree().create_timer(velocidade_digito).timeout
