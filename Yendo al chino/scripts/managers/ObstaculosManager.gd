class_name ObstacleManager
extends Node

@export var normal_markers          : Array[Marker3D] = []
@export var special_markers         : Array[Marker3D] = []
@export var normal_obstacle_scenes  : Array[PackedScene] = []
@export var special_obstacle_scenes : Array[PackedScene] = []


func _ready():
	spawn_normal_obstacles()
	spawn_special_obstacles()

func spawn_normal_obstacles():
	if normal_obstacle_scenes.is_empty():
		return

	#TODO: tener en cuenta la seed?
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	

	for marker in normal_markers:
		var scene_index = rng.randi_range(0, normal_obstacle_scenes.size() - 1)
		var scene = normal_obstacle_scenes[scene_index]
		
		instantiate_and_place(scene, marker)

func spawn_special_obstacles():
	if special_obstacle_scenes.is_empty():
		return
		
	var special_pool: Array[PackedScene] = special_obstacle_scenes.duplicate()
	special_pool.shuffle()
	
	var marker_pool: Array[Marker3D] = special_markers.duplicate()
	marker_pool.shuffle()

	var spawn_count = min(special_pool.size(), marker_pool.size())
	
	for i in range(spawn_count):
		var scene_to_spawn = special_pool.pop_front()
		var marker_to_use = marker_pool.pop_front()
		
		instantiate_and_place(scene_to_spawn, marker_to_use)

func instantiate_and_place(scene: PackedScene, marker: Marker3D):
	if not scene:
		return
		
	var instance = scene.instantiate()
	add_child(instance)
	instance.global_position = marker.global_position
