extends Node3D

# Lista fija de rutas a escenas
@export var scene_paths: Array[String] = [
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Bizcochitos Dulces.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Bizcochitos Salados.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Cacao Amarillo.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Cacao Azul.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Cacao Violeta.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto chips blanco.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto chips.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Yerba Verde.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Yerba Roja.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Pirtusas.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Mermelada Naranja.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Mermelada Frutillas.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Mermelada Arándanos.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Lata Palmitos.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Lata Jardinera.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Lata Duraznos.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Lata Champiñones.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Lata Arvejas.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto DDL Rojo.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto DDL Naranja.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto chips.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto chips blanco.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto chocogalles.tscn",
	"res://ESCENAS/Productos/Objetos/Gondola/Objeto Yerba Azul.tscn",
	"res://ESCENAS/Productos/Harinas y Fideos/Gelatina de Frambuesa.tscn",
	"res://ESCENAS/Productos/Harinas y Fideos/Gelatina de Manzana Verde.tscn",
	"res://ESCENAS/Productos/Harinas y Fideos/Bizcochuelo de Chocolate.tscn",
	"res://ESCENAS/Productos/Harinas y Fideos/Bizcochuelo de Vainilla.tscn",
	"res://ESCENAS/Productos/Harinas y Fideos/flan.tscn",
	"res://ESCENAS/Productos/Harinas y Fideos/Harina 000.tscn",
	"res://ESCENAS/Productos/Harinas y Fideos/Harina 0000.tscn",
	"res://ESCENAS/Productos/Harinas y Fideos/Harina Leudante.tscn",
	"res://ESCENAS/Productos/Higiene/Shampoo.tscn",
	"res://ESCENAS/Productos/Snacks/Chizitos Paraná Barbacoa.tscn",
	"res://ESCENAS/Productos/Snacks/Chizitos Paraná Extra Queso.tscn",
	"res://ESCENAS/Productos/Snacks/Chizitos Paraná.tscn",
	"res://ESCENAS/Productos/Snacks/Douritos Cheddar.tscn",
	"res://ESCENAS/Productos/Snacks/Douritos Jalapeño Picante.tscn",
	"res://ESCENAS/Productos/Snacks/Douritos.tscn",
	"res://ESCENAS/Productos/Snacks/Papas Pringas Asado.tscn",
	"res://ESCENAS/Productos/Snacks/Papas Pringas Barbacoa.tscn",
	"res://ESCENAS/Productos/Snacks/Papas Pringas Cebolla y Crema.tscn",
	"res://ESCENAS/Productos/Snacks/Papitas Slay's 💅🫦 Ketchup.tscn",
	"res://ESCENAS/Productos/Snacks/Papitas Slay's 💅🫦 Salame.tscn",
	"res://ESCENAS/Productos/Snacks/Papitas Slay's 💅🫦.tscn",
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
