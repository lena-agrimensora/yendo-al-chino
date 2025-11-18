class_name list_manager
extends Node

@export var margen: Vector2
@export var productos: Array[PackedScene]
@export var productos_obligatorios: Array[PackedScene]
@export var pearto: PackedScene

var mandados: Array[PackedScene]
var label

func _ready() -> void:
	generate_mandados()
	
func generate_mandados():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var productos_actuales = productos.duplicate()
	mandados.clear()
	
	for obligatorio in productos_obligatorios:
		if obligatorio in productos_actuales:
			mandados.append(obligatorio)
			productos_actuales.erase(obligatorio)
			
	
	if rng.randi_range(0, 10) == 7:
		mandados.append(pearto)
	
	@warning_ignore("narrowing_conversion")
	var total = rng.randi_range(margen.x, margen.y)
	
	while mandados.size() < total and productos_actuales.size() > 0:
		var current_index: int = rng.randi_range(0, productos_actuales.size() - 1)
		mandados.append(productos_actuales[current_index])
		productos_actuales.remove_at(current_index)
	
	mandados.shuffle()

func get_mandados():
	return mandados
	
func check_mandado(producto: RigidBody3D):
	for mandado in mandados:
		if producto.name == mandado.instantiate().name:
			return mandados.find(mandado)
	return -1
	
func set_lista(lista):
	label = lista
	
func tachar(id: int) -> void:
	label.tachar(id)
	
func destachar(id: int) -> void:
	label.destachar(id)
