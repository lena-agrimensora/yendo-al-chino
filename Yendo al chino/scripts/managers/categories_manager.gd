extends Node

var assigned_categories : Array[String] = []
#False para debug dev/test? -> hasta que tengamos suficientes categorias
var avoid_duplicates    : bool         = false


func get_unique_category(all_categories: Array) -> String:
	if not avoid_duplicates:
		return all_categories.pick_random()

	var available_categories: Array = []
	for c in all_categories:
		if not assigned_categories.has(c):
			available_categories.append(c)

	if available_categories.size() > 0:
		var selected = available_categories.pick_random()
		assigned_categories.append(selected)
		return selected

	return ""
