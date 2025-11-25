extends Node
class_name GondolaManager

@export var product_db: ProductScenesCatalog

@export var spawn_groups: Array[NodePath] = []


func _ready():
	fill_gondola_groups()


func fill_gondola_groups():
	var categories = product_db.categories.keys()
	if categories.is_empty():
		push_error("El catálogo de productos está vacío.")
		return

	if spawn_groups.is_empty():
		push_warning("No hay spawn points validos!!.")
		return

	for group_path in spawn_groups:
		var group_node = get_node_or_null(group_path)

		if group_node == null:
			continue

		var categoria = categories.pick_random()
		print("Grupo '%s' -> categoría: %s" % [group_node.name, categoria])

		var markers = get_all_spawn_points(group_node)

		for marker in markers:
			spawn_product_in_marker(marker, categoria)


func get_all_spawn_points(root: Node) -> Array[Node3D]:
	var markers: Array[Node3D] = []

	for child in root.get_children():
		if child is Marker3D:
			markers.append(child)
		elif child is Node:
			markers += get_all_spawn_points(child)

	return markers


func spawn_product_in_marker(marker: Node3D, categoria: String):
	if not product_db.has_category(categoria):
		push_warning("Categoria '%s' no existe :/" % categoria)
		return

	var scenes = product_db.get_scenes(categoria)
	if scenes.is_empty():
		push_warning("Categoria '%s' no tiene productos :c" % categoria)
		return

	var scene: PackedScene = scenes.pick_random()
	if scene:
		var instance = scene.instantiate()
		marker.add_child(instance)
		instance.global_position = marker.global_position
