extends RigidBody3D

var en_carrito: bool = false
var carrito: RigidBody3D

var agarrado: bool = false

@onready var col: CollisionShape3D

func _ready() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			col = child
			break

func agarrar() -> void:
	agarrado = true
	

func soltar() -> void:
	agarrado = false
