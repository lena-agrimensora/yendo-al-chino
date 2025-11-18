extends Node

var player := AudioStreamPlayer.new()

var sonidos = {
	"agarrar": { 
		"stream": preload("res://Sonidos (waos)/popup.wav"), 
		"volumen": -10  # Volumen normal
	},
	"tecla_r": { 
		"stream": preload("res://Sonidos (waos)/hoja2.wav"),
		"volumen": -20  # Más bajo
	},
}

func _ready():
	add_child(player)

func _unhandled_input(event):
	if event.is_action_pressed("presionar_r"):
		reproducir("tecla_r")

func reproducir(nombre: String):
	if sonidos.has(nombre):
		player.stop()
		player.stream = sonidos[nombre]["stream"]
		player.pitch_scale = randf_range(0.80, 1.10)
		player.volume_db = sonidos[nombre]["volumen"]
		player.play()
