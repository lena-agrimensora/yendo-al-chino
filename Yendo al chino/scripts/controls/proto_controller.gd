extends CharacterBody3D

@onready var timer_label = $Collider/UI/TimerLabel
@onready var game_over_screen = $Collider/UI/GameOverScreen
@onready var game_timer = $Collider/GameTimer

@export var can_move := true
@export var has_gravity := true
@export var can_jump := true
@export var can_sprint := false
@export var can_freefly := false
@export var push := 5.0
@export var grab_force := 10.0
@export var release_force := 0.4

@export_group("Grab Settings")
var grab_distance := default_grab_distance
@export var default_grab_distance := 2.0
@export var min_grab_distance := 1.5
@export var max_grab_distance := 5.0
@export var grab_distance_objetos := 3.0
@export var max_name_display_distance := 4.0

var grab: RigidBody3D
var grab_rotation_offset: Basis

@export_group("Modifiers")
@export var gravity_modifier := 1.0
@export var jump_modifier := 1.0

@export_group("Speeds")
@export var look_speed := 0.002
@export var base_speed := 7.0
@export var jump_velocity := 4.5
@export var sprint_speed := 10.0
@export var freefly_speed := 25.0

@export_group("Input Actions")
@export var input_left := "ui_left"
@export var input_right := "ui_right"
@export var input_forward := "ui_up"
@export var input_back := "ui_down"
@export var input_jump := "ui_accept"
@export var input_sprint := "sprint"
@export var input_freefly := "freefly"

var time_left: float
@export_category("Tiempo") 
@export var total_time := 50
@export var timer_always_visible := false
var timer_started = false


var mouse_captured := false
var look_rotation := Vector2()
var move_speed := 0.0
var freeflying := false

@onready var head := $Head
@onready var grab_ray := $"Head/Camera3D/Grab Ray"
@onready var grab_target := $"Head/Camera3D/Grab Ray/Grab Target"
@onready var collider := $Collider
@onready var object_name_label := $"Collider/UI/ObjectNameLabel"
@onready var hand_node = $Mano

var shown_half_time_alert := false
var shown_start_alert := false
var shown_final_alert := false


var last_whole_second := -1
var base_color := Color(1, 1, 1)
var timer_alert_tween : Tween

var rotating_grab := false
var angular_velocity := 0.0
var angular_friction := 0.90
var angular_speed_factor := 0.005

var game_over_shown := false

func _ready():
	check_input_mappings()
	capture_mouse()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	object_name_label.visible = false
	game_over_screen.visible = false
	time_left = total_time
	Global.player = self
	if Global.player:
		timer_always_visible = Global.player.timer_always_visible
	timer_always_visible = Global.timer_always_visible

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()

	if mouse_captured and event is InputEventMouseMotion:
		if not rotating_grab:
			rotate_look(event.relative)

	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _input(event):
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.pressed and key_event.keycode == KEY_R:
			$Mano.visible = !$Mano.visible

	if event is InputEventMouseButton and grab:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			grab_distance = clamp(grab_distance - 0.2, min_grab_distance, max_grab_distance)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			grab_distance = clamp(grab_distance + 0.2, min_grab_distance, max_grab_distance)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed and grab:
			rotating_grab = true
			angular_velocity = 0.0
		elif not event.pressed and grab:
			rotating_grab = false
			grab_rotation_offset = head.global_transform.basis.inverse() * grab.global_transform.basis
			grab.global_transform.basis = head.global_transform.basis * grab_rotation_offset
			angular_velocity = 0.0 

	if rotating_grab and grab and event is InputEventMouseMotion:
		angular_velocity += -event.relative.x * angular_speed_factor

func _physics_process(delta: float) -> void:
	
	if not can_move:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	if Input.is_action_pressed("Grab"):
		if grab:
			var target_pos = head.global_transform.origin - head.global_transform.basis.z * grab_distance
			var direction = target_pos - grab.global_transform.origin
			grab.linear_velocity = direction * grab_force

			if not rotating_grab:
				grab_rotation_offset = Basis()
				angular_velocity = 0.0 

			if grab.name == "Carrito":
				grab.rotation = Vector3(0, grab.rotation.y, 0)
				if not Global.carrito_coptero:
					grab.angular_velocity = Vector3.ZERO
			if grab.has_method("agarrar") and grab.name != "Carrito":
				grab.agarrar()
				var extra_rotation := Basis(Vector3.UP, deg_to_rad(180))
				grab_rotation_offset = extra_rotation * grab_rotation_offset
				grab.angular_velocity = Vector3.ZERO


		elif Input.is_action_just_pressed("Grab") and grab_ray.is_colliding():
			var target = grab_ray.get_collider()
			if target is RigidBody3D:
				grab = target
				if grab.is_in_group("Objetos"):
					grab_distance = grab_distance_objetos
				else:
					grab_distance = default_grab_distance
					grab.contact_monitor = true
					grab.max_contacts_reported = 1
					grab_rotation_offset = head.global_transform.basis.inverse() * grab.global_transform.basis
				if grab.has_method("agarrar"):
					grab.agarrar()

				object_name_label.text = grab.name
				object_name_label.visible = true
				await get_tree().create_timer(1.0).timeout
				object_name_label.visible = false

	elif Input.is_action_just_released("Grab") and grab:
		release()

	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion: Vector3 = (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return

	if has_gravity and not is_on_floor():
		velocity += get_gravity() * gravity_modifier * delta

	if can_jump and Input.is_action_just_pressed(input_jump) and is_on_floor():
		velocity.y = jump_velocity * jump_modifier

	move_speed = sprint_speed if can_sprint and Input.is_action_pressed(input_sprint) else base_speed

	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if move_dir != Vector3.ZERO:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.y = 0

	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir = -c.get_normal()
			var vel_diff = velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			c.get_collider().apply_central_force(push_dir * vel_diff * push)

	if rotating_grab and grab:
		var rot = grab.rotation_degrees
		rot.y += rad_to_deg(angular_velocity)
		rot.x = 0
		rot.z = 0
		grab.rotation_degrees = rot
		angular_velocity *= angular_friction
	move_and_slide()

func release():
	if grab:
		if grab.has_method("soltar"):
			grab.soltar()
			grab.contact_monitor = false
			grab.max_contacts_reported = 0
			grab.linear_velocity *= release_force
			grab = null
			grab_distance = default_grab_distance 
			rotating_grab = false
			angular_velocity = 0.0

func rotate_look(rot_input: Vector2):
	look_rotation.x = clamp(look_rotation.x - rot_input.y * look_speed, deg_to_rad(-70), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed  
	rotation.y = look_rotation.y
	head.rotation.x = look_rotation.x

func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _process(delta):
	if timer_started:
		if time_left > 0:
			time_left -= delta
			update_timer_label()

			if not shown_start_alert and time_left >= total_time * 0.99:
				shown_start_alert = true
				play_timer_intro_alert()

			if not shown_half_time_alert and time_left <= total_time * 0.5:
				shown_half_time_alert = true
				play_timer_intro_alert()

			if not shown_final_alert and time_left <= 10:
				shown_final_alert = true
				show_timer_final_alert()
				last_whole_second = int(time_left)
				timer_label.scale = Vector2.ONE
				timer_label.modulate = base_color

			if shown_final_alert and time_left <= 10:
				var current_second = int(time_left)
				if current_second != last_whole_second:
					last_whole_second = current_second
					timer_label.scale += Vector2(0.2, 0.2)
					timer_label.set_pivot_offset(timer_label.size / 2)
				# Cambiar color de blanco a rojo
				var t = 1.0 - (time_left / 10.0)  # va de 0 a 1
				timer_label.modulate = base_color.lerp(Color(1, 0, 0), t)
		else:
			time_left = 0
			show_game_over()
		
	if grab_ray.is_colliding():
		var target = grab_ray.get_collider()
		var distance = head.global_transform.origin.distance_to(target.global_transform.origin)

		if target is RigidBody3D and distance <= max_name_display_distance:
			object_name_label.text = target.name
			object_name_label.visible = true
	else:
		object_name_label.visible = false

	
func play_timer_intro_alert():
	if timer_always_visible:
		timer_label.visible = true
		timer_label.modulate.a = 1.0
		return

	if timer_alert_tween:
		timer_alert_tween.kill()

	timer_label.visible = true
	timer_alert_tween = get_tree().create_tween()
	timer_alert_tween.set_loops(4)
	timer_alert_tween.tween_property(timer_label, "modulate:a", 0.0, 0.3)
	timer_alert_tween.tween_property(timer_label, "modulate:a", 1.0, 0.3)
	timer_alert_tween.tween_callback(Callable(self, "solid_then_fade_timer_label")).set_delay(0.0)

func solid_then_fade_timer_label():
	timer_label.modulate.a = 1.0
	var solid_tween = get_tree().create_tween()
	solid_tween.tween_callback(Callable(self, "_fade_out_timer_label")).set_delay(3.0)

func _fade_out_timer_label():
	if timer_always_visible:
		timer_label.modulate.a = 1.0
	else:
		var fade_tween = get_tree().create_tween()
		fade_tween.tween_property(timer_label, "modulate:a", 0.0, 1.0)

func _show_timer():
	$TimerNode.show()
	if not timer_always_visible:
		$AnimationPlayer.play("HideTimer")

func show_timer_final_alert():
	if timer_alert_tween:
		timer_alert_tween.kill()
	timer_label.visible = true
	timer_label.modulate.a = 1.0

func update_timer_label():
	@warning_ignore("integer_division")
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	
func show_game_over():
	game_over_screen.visible = true
	game_over_screen.modulate.a = 0.0
	var tween := get_tree().create_tween()
	tween.tween_property(game_over_screen, "modulate:a", 1.0, 1.0)
	tween.tween_callback(Callable(self, "_on_game_over_fade_complete")).set_delay(0.0)

func _on_game_over_fade_complete():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_reintentar_button_pressed():
	get_tree().reload_current_scene()

func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("No InputAction for input_left")
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("No InputAction for input_right")
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("No InputAction for input_forward")
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("No InputAction for input_back")
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("No InputAction for input_jump")
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("No InputAction for input_sprint")
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("No InputAction for input_freefly")
		can_freefly = false

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ESCENAS/UI/menú.tscn")

func show_timer() -> void:
	timer_started = true
	game_timer.start()
	update_timer_label()
