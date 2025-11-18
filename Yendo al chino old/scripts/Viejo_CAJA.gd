extends CharacterBody3D

@onready var rotador := $"VIEJO SENTADO"

func _process(_delta):
	var cam := get_viewport().get_camera_3d()
	if cam and rotador:
		var cam_pos = cam.global_transform.origin
		var my_pos = rotador.global_transform.origin
		cam_pos.y = my_pos.y
		rotador.look_at(cam_pos, Vector3.UP)
		rotador.rotation.x = 0
		rotador.rotation.z = 0
