extends Node
class_name ObstaculosManager

const OBSTACULOS_BASE_PATH := "res://scenes/muebles/Obstaculos/"
var spawn_points: Array[Marker3D]
var obstacles_array: Array[PackedScene]

func _ready() -> void:
	_retrieve_spawn_points()
	_get_all_obstacle_scenes()
	_spawn_obstacles()
	
func _retrieve_spawn_points() -> void:	
	var children = get_children()
	for child in children:
		if(child.is_class("Marker3D")):
			spawn_points.append(child)
	print(children)
	return
	
func _spawn_obstacles() -> void:
	if(spawn_points.size() <= 0 or obstacles_array.size() <= 0):
		print("Complicado spawnear algo en estas condiciones.")
		return
		
	for point in spawn_points:
		_spawn_random_obstacle(obstacles_array,point)

func _spawn_random_obstacle(obst_array: Array, spawn_point: Marker3D) -> void:
	var rng = RandomNumberGenerator.new()
	var index = rng.randi_range(0, obst_array.size() - 1)
	var obs_scene = obstacles_array[index]
	var obs_instance = obs_scene.instantiate()
	spawn_point.add_child(obs_instance)
	obs_instance.transform = Transform3D.IDENTITY 
	return

func _get_all_obstacle_scenes() -> void:
	var dir: = DirAccess.open(OBSTACULOS_BASE_PATH)
	if(!dir):
		print("No existe el directorio :(")
		return
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				var scene_path = OBSTACULOS_BASE_PATH + file_name
				var packed_scene: PackedScene = load(scene_path)
				if packed_scene:
					obstacles_array.append(packed_scene)
			file_name = dir.get_next()
		dir.list_dir_end()
	pass
