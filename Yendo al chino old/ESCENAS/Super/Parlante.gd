extends RigidBody3D

var en_carrito: bool = false
var carrito: RigidBody3D

var agarrado: bool = false

@onready var col: CollisionShape3D

var escala_original: Vector3
var escala_objetivo: Vector3

func _ready() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			col = child
			break
	escala_original = scale
	escala_objetivo = escala_original

func agarrar() -> void:
	agarrado = true
	if en_carrito:
		sacar_de_carrito()
	
	collision_layer = 1 << 2

func soltar() -> void:
	agarrado = false
	collision_layer = 1 << 0


func sacar_de_carrito() -> void:
	carrito._remove_item(self)
	en_carrito = false
	activar_colision()
	scale = escala_original
	await get_tree().process_frame
	animar_salida()

	PhysicsServer3D.body_set_mode(self.get_rid(), PhysicsServer3D.BODY_MODE_RIGID)

func desactivar_colision() -> void:
	collision_layer = 2

func activar_colision() -> void:
	await get_tree().create_timer(1).timeout
	collision_layer = 1

func mirar_adelante(dir: Vector3) -> void:
	look_at(global_position + dir, Vector3.UP)

func animar_entrada() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", escala_original * 0.7, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.connect("finished", Callable(self, "_on_animar_entrada_finished"))
	
func rechazar_entrada() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", escala_original * 1.2, 0.1)
	tween.tween_property(self, "scale", escala_original, 0.1)

func _on_animar_entrada_finished() -> void:
	escala_objetivo = escala_original * 0.7
	scale = escala_objetivo

func animar_salida() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", escala_original * 1.2, 0.15).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", escala_original, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.connect("finished", Callable(self, "_on_animar_salida_finished"))

func _on_animar_salida_finished() -> void:
	escala_objetivo = escala_original
	scale = escala_objetivo
