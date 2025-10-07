extends RigidBody3D

@export var altura_flotacion := 1.0
@export var fuerza_flotacion := 10.0
@export var velocidad_rotacion_y := 1.5

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var from = global_transform.origin
	var to = from - Vector3.UP * (altura_flotacion + 1.0)

	var ray_params := PhysicsRayQueryParameters3D.create(from, to)
	ray_params.exclude = [self]

	var space_state = get_world_3d().direct_space_state
	var resultado = space_state.intersect_ray(ray_params)

	if resultado:
		var distancia = from.y - resultado.position.y
		var diferencia = altura_flotacion - distancia
		var fuerza_aplicar = diferencia * fuerza_flotacion
		apply_central_force(Vector3.UP * fuerza_aplicar)

	# Rotar suavemente sobre el eje Y
	var rotacion = Vector3(0, velocidad_rotacion_y, 0)
	apply_torque_impulse(rotacion * state.step)

	# Limitar velocidad angular en el eje Y
	var max_angular_speed_y := 2.0
	if abs(angular_velocity.y) > max_angular_speed_y:
		angular_velocity.y = clamp(angular_velocity.y, -max_angular_speed_y, max_angular_speed_y)
