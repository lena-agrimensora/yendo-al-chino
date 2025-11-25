extends Node
class_name GondolasManager

@export var gondolas_laterales: Array[PackedScene] = []
@export var gondolas_especiales: Array[PackedScene] = []

@export var spawn_points_laterales: Array[Marker3D] = []
@export var spawn_points_especiales: Array[Marker3D] = []

func _ready() -> void:
	_spawn_gondolas(gondolas_laterales, spawn_points_laterales)
	_spawn_gondolas(gondolas_especiales, spawn_points_especiales)



func _spawn_gondolas(gondolas: Array[PackedScene], spawns: Array[Marker3D]) -> void:
	#TODO: por ahora DOS y no hardcodear
	if gondolas.size() != 2 or spawns.size() != 2:
		return

	var escenas := gondolas.duplicate()

	escenas.shuffle()

	for i in range(2):
		var scene: PackedScene = escenas[i]
		var spawn: Marker3D = spawns[i]

		var instance = scene.instantiate()
		spawn.add_child(instance)
