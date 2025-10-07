class_name list_manager
extends Node

@export var margen: Vector2
@export var productos: Array[PackedScene]
@export var productos_obligatorios: Array[PackedScene]
@export var pearto: PackedScene

var all_products: Dictionary 

var mandados: Array[PackedScene]
var mandados_list: Array[String]
var label

func _ready() -> void:
	all_products = ProductScanner.all_products_list
	generate_mandados()	
	
func generate_mandados():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var productos_actuales = productos.duplicate()
	mandados.clear()
	
	if rng.randi_range(0, 10) == 7:
		mandados.append(pearto)
	
	@warning_ignore("narrowing_conversion")
	var total = rng.randi_range(margen.x, margen.y)
	
	while mandados_list.size() < total:
		var product = get_random_product(all_products)
		var current_index: int = rng.randi_range(0, productos_actuales.size() - 1)
		mandados_list.append(product)
		productos_actuales.remove_at(current_index)
	
	mandados_list.shuffle()

func get_mandados():
	return mandados_list
	
func check_mandado(producto: RigidBody3D):
	for mandado in mandados_list:
		if producto.name == mandado:
			return mandados_list.find(mandado)
	return -1
	
func set_lista(lista):
	label = lista
	
func tachar(id: int) -> void:
	label.tachar(id)
	
func destachar(id: int) -> void:
	label.destachar(id)

func get_random_product(list: Dictionary) -> String:
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	if list.is_empty():
		return ""
	
	var categoria_candidates = list.keys()
	var categoria = categoria_candidates[rng.randi_range(0, categoria_candidates.size() - 1)]

	var subcategorias_candidates = list[categoria].keys()
	var subcategoria = subcategorias_candidates[rng.randi_range(0, subcategorias_candidates.size() - 1)]

	var products_list = list[categoria][subcategoria]
	if products_list.is_empty():
		return ""

	var product_name = products_list[rng.randi_range(0, products_list.size() - 1)]
	
	list[categoria][subcategoria].erase(product_name)

	if list[categoria][subcategoria].is_empty():
		list[categoria].erase(subcategoria)

	if list[categoria].is_empty():
		list.erase(categoria)

	return product_name
