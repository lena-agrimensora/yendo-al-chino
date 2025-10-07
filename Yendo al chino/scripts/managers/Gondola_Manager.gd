extends Node
class_name GondolaManager

@export var products_spawn_config: Array[ProductGroups]
@export var product_db: ProductScenesCatalog

const PRODUCTS_BASE_PATH := "res://productos/"


func _ready():
	#TODO: Validar que el path exista y validar que spawn points root exista
	if EnvConfig.is_dev():
		print("Estoy en dev!!!")
	fill_gondolas()

func fill_gondolas():
	if products_spawn_config.is_empty():
		print("No hay configs de productos para esta gondola!!")
		return
	
	
	for group in products_spawn_config:
		var group_spawn_node = get_node_or_null(group.target_spawn_points)

		if group_spawn_node == null:
			print("No tengo spawn points validos para este grupo :(")
			continue
		
		var spawn_points = get_all_spawn_points(group_spawn_node)
		
		if spawn_points.is_empty():
			continue
		
		var total_points: int = spawn_points.size()
		var total_percentage: float = 0.0
		
		for config in group.products_config:
			total_percentage += config.porcentaje

		if total_percentage < 0.0 or total_percentage > 100.0:
			push_error("Numeros entre 0 y 100 por favor!")
			continue
		
		#TODO: hacer funcion? Basicamente a partir de aca tengo todo lo que necesito para instanciar ya validado
		var total_to_fill: int = int(round(total_points * (total_percentage / 100.0)))
		var points_to_fill = spawn_points.slice(0, total_to_fill)
		
		var product_dist := []
		for prod_config in group.products_config:
			product_dist.append({
				"config": prod_config,
				"cantidad": int(round((prod_config.porcentaje / total_percentage) * total_to_fill))
			})
		
		#TODO: hacer funcion?
		var current_index := 0
		for dist in product_dist:
			for i in range(dist.cantidad):
				if current_index >= points_to_fill.size():
					break
				var point = points_to_fill[current_index]
				current_index += 1

				instantiate_product_on_point(dist.config, point)
				
func get_all_spawn_points(root: Node) -> Array[Node3D]:
	var markers: Array[Node3D] = []
	for child in root.get_children():
		if child is Marker3D:
			markers.append(child)
		elif child is Node:
			#Recursividad :3
			markers += get_all_spawn_points(child)
	return markers

func instantiate_product_on_point(config: ProductConfig, point: Node3D):
	var category: String = config.categoria
	
	if not product_db.has_category(category):
		push_warning("No existe '%s' como categoria!!!!" % category)
		return
	
	var scenes: Array = product_db.get_scenes(category)
	if scenes.is_empty():
		push_warning("No hay productos para '%s'" % category)
		return
	
	var product_scene: PackedScene = scenes.pick_random()
	if product_scene:
		var instance = product_scene.instantiate()
		point.add_child(instance)
		instance.global_position = point.global_position

#func get_random_product_by_category(path: String, isAllCategories) -> PackedScene:
	##TODO: hacer algo con el isAllCategories (en caso de que se pida)
	#var scene_files := []
	#var dir := DirAccess.open(path)
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#if file_name.ends_with(".tscn"):
				#scene_files.append(path + "/" + file_name)
			#file_name = dir.get_next()
		#dir.list_dir_end()
#
	#if scene_files.is_empty():
		#return null
	##TODO: validar que el load le haya pegado a una escena valida?
	#return load(scene_files.pick_random())
