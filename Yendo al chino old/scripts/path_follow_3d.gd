extends PathFollow3D

@export var velocidad: float = 5.0

func _process(delta: float) -> void:
	progress += velocidad * delta
