extends Node3D

@export var spawn_count: int = 10
@export var spawn_area: Vector3 = Vector3(10, 0, 10)
@export var spawn_chance: float = 0.5
@export var scenes_folder_path: String = "res://ESCENAS/Productos/Objetos/Desayuno/"

var scene_paths: Array = []
var scene_resources: Array = []

func _ready():
	randomize()
	load_scene_paths()
	preload_scenes()
	generate_objects()

func load_scene_paths():
	scene_paths.clear()
	load_scene_paths_recursive(scenes_folder_path)

func load_scene_paths_recursive(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if file_name != "." and file_name != "..":
					load_scene_paths_recursive(path + "/" + file_name)
			else:
				if file_name.ends_with(".tscn"):
					scene_paths.append(path + "/" + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()

func preload_scenes():
	scene_resources.clear()
	for path in scene_paths:
		var res = load(path)
		if res:
			scene_resources.append(res)

func generate_objects():
	if scene_resources.is_empty():
		return

	var spacing = 1.2
	var start_x = -((spawn_count - 1) * spacing) / 2

	var spawned_count = 0
	var attempts = 0
	var max_attempts = spawn_count * 3  # evitar loop infinito

	while spawned_count < spawn_count and attempts < max_attempts:
		attempts += 1
		if randf() <= spawn_chance:
			var random_scene = scene_resources[randi() % scene_resources.size()]
			var instance = random_scene.instantiate() as RigidBody3D
			instance.position = Vector3(start_x + spawned_count * spacing, 0.0, 0.0)
			PhysicsServer3D.body_set_mode(instance.get_rid(), PhysicsServer3D.BODY_MODE_STATIC)
			add_child(instance)
			start_physics_delay(instance, 2.0)
			spawned_count += 1

func start_physics_delay(body: RigidBody3D, delay_seconds: float) -> void:
	call_deferred("_async_start_physics_delay", body, delay_seconds)

func _async_start_physics_delay(body: RigidBody3D, delay_seconds: float) -> void:
	await get_tree().create_timer(delay_seconds).timeout
	PhysicsServer3D.body_set_mode(body.get_rid(), PhysicsServer3D.BODY_MODE_RIGID)
	body.linear_velocity = Vector3.ZERO
	body.angular_velocity = Vector3.ZERO
