extends Control

@onready var anim = $AnimatedSprite2D
@onready var anim2 = $AnimatedSprite2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	anim.play("Confeti")
	anim2.play("Confeti")

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/menu.tscn")

func _on_reintentar_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/loading_screen.tscn")
