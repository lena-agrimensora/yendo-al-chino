extends Node3D

# Lista fija de rutas a escenas
@export var scene_paths: Array[String] = [
	"res://productos/verduleria/Objeto TetoPera.tscn",
]

func _ready():
	randomize()
	call_deferred("spawn_random_at_marker")

func spawn_random_at_marker():
	if scene_paths.is_empty():
		return

	# Obtener todos los hijos Marker3D
	var markers: Array[Marker3D] = []
	for child in get_children():
		if child is Marker3D:
			markers.append(child)

	if markers.is_empty():
		return

	# Elegir un Marker3D al azar
	var chosen_marker: Marker3D = markers[randi() % markers.size()]

	# Elegir una escena al azar
	var scene_path: String = scene_paths[randi() % scene_paths.size()]
	var scene = load(scene_path)
	if scene:
		var instance = scene.instantiate()
		chosen_marker.add_child(instance)
		instance.transform = Transform3D.IDENTITY
	
