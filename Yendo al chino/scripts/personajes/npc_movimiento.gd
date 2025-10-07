extends CharacterBody3D

@onready var sprite := $Sprite3D

func _process(delta):
	if get_viewport().get_camera_3d():
		var cam_pos = get_viewport().get_camera_3d().global_transform.origin
		var sprite_pos = sprite.global_transform.origin
		cam_pos.y = sprite_pos.y
		sprite.look_at(cam_pos, Vector3.UP)
