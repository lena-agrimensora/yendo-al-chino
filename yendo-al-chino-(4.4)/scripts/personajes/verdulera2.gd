extends Node3D

@onready var label = $SubViewport/TextBox/MarginContainer/Label
@onready var area = $Area3D
@onready var timer = $LetterDisplayTimer
@onready var sonido_texto = $AudioStreamPlayer3D

var ya_mostrado = false
var lineas_de_dialogo = [
	"Pibe, Agarra el carrito",
	"Agarra lo que necesites",
	"Y RAJA de aca",
	"...",
	"...",
	"Tonto"
]

var texto_actual = ""
var linea_actual = 0
var letra_index = 0
var mostrando = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	$Sprite3D.visible = false
	timer.timeout.connect(_mostrar_siguiente_letra)
	timer.wait_time = 0.05 
	timer.one_shot = false
	timer.autostart = false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "ProtoController" and not mostrando and not ya_mostrado:
		ya_mostrado = true
		mostrando = true
		$Sprite3D.visible = true
		_empezar_linea()

func _empezar_linea():
	if linea_actual < lineas_de_dialogo.size():
		texto_actual = lineas_de_dialogo[linea_actual]
		label.text = ""
		letra_index = 0
		timer.start()
	else:
		timer.stop()
		mostrando = false
		linea_actual = 0
		$Sprite3D.visible = false

func _mostrar_siguiente_letra():
	if letra_index < texto_actual.length():
		label.text += texto_actual[letra_index]
		letra_index += 1
		
		if texto_actual[letra_index - 1] != " ":
			sonido_texto.stop()
			sonido_texto.pitch_scale = randf_range(0.80, 1.10)
			sonido_texto.play()

	else:
		timer.stop()
		linea_actual += 1
		await get_tree().create_timer(0.5).timeout
		_empezar_linea()
