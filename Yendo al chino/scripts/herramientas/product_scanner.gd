extends Node

var all_products_list: Dictionary = {}

func scan_productos(path: String = "res://productos") -> Dictionary:
	var all_products_dict: Dictionary = {}
	_recorrer_directorio(path, all_products_dict)
	return all_products_dict

func _recorrer_directorio(path: String, all_products_dict: Dictionary) -> void:
	var dir = DirAccess.open(path)
	if not dir:
		push_error("No se pudo abrir: " + path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue

		var full_path = path.path_join(file_name)

		if dir.current_is_dir():
			_recorrer_directorio(full_path, all_products_dict)
		elif file_name.ends_with(".tscn"):
			var relative_path = full_path.replace("res://productos/", "")
			var parts = relative_path.split("/")
			
			if parts.size() < 2:
				file_name = dir.get_next()
				continue

			var categoria = parts[0]
			var subcategoria = parts[1]
			var packed_scene = load(full_path)
			var display_name: String = ""
			if packed_scene is PackedScene:
				var state = packed_scene.get_state()
				display_name = state.get_node_name(0)

			if not all_products_dict.has(categoria):
				all_products_dict[categoria] = {}
			if not all_products_dict[categoria].has(subcategoria):
				all_products_dict[categoria][subcategoria] = []
			
			all_products_dict[categoria][subcategoria].append(display_name)

		file_name = dir.get_next()
	
	dir.list_dir_end()

func _ready() -> void:
	all_products_list = scan_productos()
