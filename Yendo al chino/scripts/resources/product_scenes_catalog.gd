extends Resource
class_name ProductScenesCatalog

@export var categories: Dictionary = {}

func has_category(cat: String) -> bool:
	return categories.has(cat)

func get_scenes(cat: String) -> Array:
	return categories.get(cat, [])
