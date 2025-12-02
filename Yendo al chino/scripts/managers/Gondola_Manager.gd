class_name GondolaManager
extends Node

@export var product_db         : ProductScenesCatalog

@export var special_group_one  : NodePath
@export var common_group_one   : Array[NodePath]

@export var special_group_two  : NodePath
@export var common_group_two   : Array[NodePath]

var spawned_products           : Array[String] = []

func _ready():
	var category_left    = ""
	var category_right   = ""
	var all_categories   = product_db.categories.keys()

	if all_categories.size() == 0:
		return

	if all_categories.size() == 1:
		category_left = all_categories[0]
		category_right = all_categories[0]
	else:
		category_left = CategoryManager.get_unique_category(all_categories)
		var available_for_right = all_categories.duplicate()
		available_for_right.erase(category_left)
		if available_for_right.is_empty():
			category_right = category_left
		else:
			category_right = CategoryManager.get_unique_category(available_for_right)


	if category_left != "" and category_right != "":
		fill_side(category_left, special_group_one, common_group_one)
		fill_side(category_right, special_group_two, common_group_two)

func fill_side(main_category: String, special_path: NodePath, common_groups: Array[NodePath]):
	if main_category.is_empty() or not product_db.has_category(main_category):
		return

	var sub_categories: Array[String] = product_db.get_subcategories(main_category)
	if sub_categories.is_empty():
		return

	if main_category == 'verduleria':
		var all_groups: Array[NodePath] = []
		if special_path != null:
			all_groups.append(special_path) 
		all_groups.append_array(common_groups)
		fill_unique_subcategories_per_group(main_category, sub_categories, all_groups)

	else:
		fill_standard_gondola(main_category, sub_categories, special_path, common_groups)

func fill_standard_gondola(main_category: String, sub_categories: Array[String], special_path: NodePath, common_groups: Array[NodePath]):
	var pool = sub_categories.duplicate()
	
	var special_node = get_node_or_null(special_path)
	if special_node != null and not pool.is_empty():
		var special_markers = get_all_spawn_points(special_node)
		if not special_markers.is_empty():
			var special_subcat = pool.pick_random()
			if special_subcat != null:
				pool.erase(special_subcat)
				for m in special_markers:
					spawn_product_in_subcategory(m, main_category, special_subcat)

	if common_groups.is_empty() or pool.is_empty():
		return

	var current_pool = pool.duplicate()
	
	for group_path in common_groups:
		var node = get_node_or_null(group_path)
		if node == null:
			continue
			
		var markers = get_all_spawn_points(node)
		if markers.is_empty():
			continue

		if current_pool.is_empty():
			current_pool = pool.duplicate()

		var subcat = current_pool.pop_front()
		if subcat == null:
			continue

		for m in markers:
			spawn_product_in_subcategory(m, main_category, subcat)


func fill_unique_subcategories_per_group(main_category: String, sub_categories: Array[String], all_groups: Array[NodePath]):
	var pool = sub_categories.duplicate()
	var current_pool = pool.duplicate()

	for group_path in all_groups:
		var node = get_node_or_null(group_path)
		if node == null:
			continue
			
		var markers = get_all_spawn_points(node)
		if markers.is_empty():
			continue

		if current_pool.is_empty():
			current_pool = pool.duplicate()

		var subcat = current_pool.pop_front()
		if subcat == null:
			continue

		for m in markers:
			spawn_product_in_subcategory(m, main_category, subcat)

func get_all_spawn_points(root: Node) -> Array[Node3D]:
	var markers: Array[Node3D] = []
	for child in root.get_children():
		if child is Marker3D:
			markers.append(child)
		elif child is Node:
			markers += get_all_spawn_points(child)
	return markers

func spawn_product_in_subcategory(marker: Node3D, main_category: String, subcat: String):
	var scenes = product_db.get_scenes_from_subcategory(main_category, subcat)
	if scenes.is_empty():
		return

	var scene: PackedScene = scenes.pick_random()
	if scene:
		var instance = scene.instantiate()
		marker.add_child(instance)
		instance.global_position = marker.global_position

		var product_name = instance.name
		if not spawned_products.has(product_name):
			spawned_products.append(product_name)
