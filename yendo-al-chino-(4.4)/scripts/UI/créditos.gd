extends Control

@onready var texture_rect_2: TextureRect = $TextureRect2

func _ready():
	texture_rect_2.visible = false

func _on_volver_menu_pressed() -> void:
	self.visible = false
	texture_rect_2.visible = false

func _on_pag_siguiente_pressed() -> void:
	texture_rect_2.visible = true

func _on_pag_anterior_pressed() -> void:
	texture_rect_2.visible = false
