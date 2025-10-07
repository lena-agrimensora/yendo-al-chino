extends Area3D

var ya_mostrado = false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "ProtoController" and !ya_mostrado:
		$"../StaticBody3D/Globo de texto".mostrar_dialogo(2)
