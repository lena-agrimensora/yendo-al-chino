extends Node3D

# Lista fija de rutas a escenas
@export var scene_paths: Array[String] = [
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Leche Descremada.tscn",
	"res://ESCENAS/Productos/Objetos/Heladeras/Objeto Leche Entera.tscn",
	"res://ESCENAS/Productos/Objetos/Heladeras/Objeto Leche Sancor.tscn"
]

@export var spawn_chance: float = 1.0  # Entre 0.0 (nunca) y 1.0 (siempre)

func _ready():
	randomize()
	call_deferred("spawn_random_at_markers")

func spawn_random_at_markers():
	if scene_paths.is_empty():
		return

	for marker in get_children():
		if marker is Marker3D:
			if randf() <= spawn_chance:
				var scene_path = scene_paths[randi() % scene_paths.size()]
				var scene = load(scene_path)
				if scene:
					var instance = scene.instantiate()
					marker.add_child(instance)
					instance.transform = Transform3D.IDENTITY
