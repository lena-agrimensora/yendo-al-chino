extends Control

@onready var opciones_menu: CanvasLayer = $"Opciones Menu"
@onready var créditos: Control = $Créditos

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	opciones_menu.visible = false
	créditos.visible = false

func _on_nuevo_juego_pressed():
	get_tree().change_scene_to_file("res://ESCENAS/main.tscn")
func _on_créditos_pressed():
	créditos.visible = true
func _on_salir_pressed():
	get_tree().quit()
func _on_ajustes_pressed() -> void:
	opciones_menu.visible = true
