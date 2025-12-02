extends Resource
class_name ProductScenesCatalog

@export var categories: Dictionary = {}

func has_category(category: String) -> bool:
	return categories.has(category)

func get_scenes(category: String) -> Array:
	return categories.get(category, [])
	
func get_subcategories(main_category: String) -> Array[String]:
	if not categories.has(main_category):
		return []

	var keys = categories[main_category].categories.keys()

	var result: Array[String] = []
	for k in keys:
		result.append(String(k))

	return result



func has_subcategory(main_category: String, subcat: String) -> bool:
	if not categories.has(main_category):
		return false
	return categories[main_category].categories.has(subcat)


func get_scenes_from_subcategory(main_category: String, subcat: String) -> Array[PackedScene]:
	if not categories.has(main_category):
		return []

	var subdict = categories[main_category].categories
	if not subdict.has(subcat):
		return []

	var raw_array: Array = subdict[subcat]

	var result: Array[PackedScene] = []
	for item in raw_array:
		if item is PackedScene:
			result.append(item)
		else:
			return [null]

	return result
