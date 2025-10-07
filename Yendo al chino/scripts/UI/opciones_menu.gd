extends CanvasLayer
@onready var menú: Control = $".."

var masterBus = AudioServer.get_bus_index("Master")
var volume: float = 10

@onready var volume_label = $Fondo/ValumeSeter/Label

func _ready():
	$Fondo/CarritoCoptero/CheckButton.set_pressed_no_signal(Global.carrito_coptero) 
	$"Fondo/Tipo de Timer/CheckButton".set_pressed_no_signal(Global.timer_always_visible)
	
	if AudioServer.is_bus_mute(masterBus):
		edit_volume_label(0)
		volume = 0
	else:
		var value = AudioServer.get_bus_volume_db(masterBus)
		volume = db_to_linear(value)
		edit_volume_label(volume)
		
	
	#var check_button = get_node("TextureRect/TextureButton/CheckButton")
	#if check_button:
		#check_button.button_pressed = Global.timer_always_visible
	#if check_button:
		#check_button.button_pressed = Global.carrito_coptero

func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.timer_always_visible = toggled_on
	if Global.player:
		Global.player.timer_always_visible = toggled_on

func _on_salir_pressed() -> void:
	get_tree().paused = false
	self.visible = false

func carrito_coptero(toggled_on: bool) -> void:
	Global.carrito_coptero = toggled_on

func _on_mostrar_controles_pressed() -> void:
	var label = get_node("Fondo/Mostrar controles/ControlesLabel")
	label.visible = not label.visible
	var ABlackImage = get_node("Fondo/ABlackImage")
	ABlackImage.visible = not ABlackImage.visible

func subir_volumen() -> void:
	if volume < 10:
		volume += 1
		AudioServer.set_bus_volume_db(masterBus, linear_to_db(volume))
	if volume != 0:
		AudioServer.set_bus_mute(masterBus, false)
	edit_volume_label(volume)

func bajar_volumen() -> void:
	if volume > 0:
		volume -= 1
		AudioServer.set_bus_volume_db(masterBus, linear_to_db(volume))
	if volume == 0:
		AudioServer.set_bus_mute(masterBus, true)
	edit_volume_label(volume)

func edit_volume_label(text: float) -> void:
	volume_label.text = str(text*10) + "%"
