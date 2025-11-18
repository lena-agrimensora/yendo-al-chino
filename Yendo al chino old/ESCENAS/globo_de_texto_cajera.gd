extends Node3D

@onready var label = $Sprite3D/SubViewport/TextBox/MarginContainer/Label
@onready var timer = $Sprite3D/SubViewport/TextBox/LetterDisplayTimer
@onready var sonido_texto = $AudioStreamPlayer3D

var lineas_de_dialogo_uno = [
	"Seguro que tenes todo?",
]

var lineas_de_dialogo_dos = [
	"No te alcanza para todo esto",
]

var lineas_de_dialogo_tres = [
	"Terminá rapido",
	"Traeme el carrito y te cobro",
]

var dialogos = [lineas_de_dialogo_uno, lineas_de_dialogo_dos, lineas_de_dialogo_tres]

var dialogo_actual

var texto_actual = ""
var linea_actual = 0
var letra_index = 0
var mostrando = false

func _ready():
	$Sprite3D.visible = false
	timer.timeout.connect(_mostrar_siguiente_letra)
	timer.wait_time = 0.08
	timer.one_shot = false
	timer.autostart = false


func _empezar_linea(dialogo):
	dialogo_actual = dialogo
	if linea_actual < dialogo.size():
		texto_actual = dialogo[linea_actual]
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
		_empezar_linea(dialogo_actual)

func mostrar_dialogo(index: int) -> void:
	if !mostrando:
		mostrando = true
		$Sprite3D.visible = true
		_empezar_linea(dialogos[index])
