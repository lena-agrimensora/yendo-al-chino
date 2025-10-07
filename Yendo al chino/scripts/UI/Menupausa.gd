extends CanvasLayer

@onready var pause_menu = $"/root/Main/PauseMenu"

var hiden = true

var mouse_capture := true

func _ready():
	hide()

func show_menu():
	get_tree().paused = true
	show()
	hiden = false
	release_mouse()

func hide_menu():
	get_tree().paused = false
	hide()
	hiden = true
	capture_mouse()

func _on_reanudar_pressed() -> void:
	hide_menu()

func _on_salir_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/interface/menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if !hiden:
			hide_menu()
		else:
			show_menu()

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
