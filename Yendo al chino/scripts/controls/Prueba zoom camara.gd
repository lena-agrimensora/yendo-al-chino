extends Node3D

@export var duracion_zoom: float = 1.0
@export var tiempo_en_destino: float = 1.5

@onready var area := $Area3D
@onready var camara_destino := $Marker3D

var ya_mostrado := false
var ya_terminado := false

var cam_original
var cam_temporal
var player

@export var push_time: float
var actual_time = 0
var pushed = false

func _ready():
	if !area.body_entered.is_connected(Callable(self, "_on_body_entered")):
		area.body_entered.connect(_on_body_entered)
	#area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "ProtoController" and not ya_mostrado:
		ya_mostrado = true

		var proto = get_node("../ProtoController")
		if proto.has_method("set_can_move"):
			proto.set_can_move(false)
		elif "can_move" in proto:
			proto.can_move = false

		var camara_original = proto.get_node("Head/Camera3D")
		hacer_zoom(camara_original, camara_destino, proto)

func hacer_zoom(camara_original: Camera3D, destino: Marker3D, jugador: Node3D = null):
	var camara_temp := Camera3D.new()
	get_tree().current_scene.add_child(camara_temp)
	camara_temp.global_transform = camara_original.global_transform
	camara_temp.current = true
	
	$Control.visible = true
	
	camara_original.current = false
	
	cam_original = camara_original
	cam_temporal = camara_temp
	player = jugador
	
	var tween := create_tween()
	tween.tween_property(
		camara_temp,
		"global_transform",
		destino.global_transform,
		duracion_zoom
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#tween.chain().tween_interval(tiempo_en_destino)
	await get_tree().create_timer(tiempo_en_destino + .5).timeout
	
	if camara_temp != null:
		sacar_zoom(camara_original, camara_temp, jugador)

func sacar_zoom(camara_original: Camera3D, camara_temp: Camera3D, jugador: Node3D = null):
	var tween := create_tween()
	tween.tween_property(
		camara_temp,
		"global_transform",
		camara_original.global_transform,
		duracion_zoom
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.chain().tween_callback(func():
		camara_original.current = true
		camara_temp.queue_free()
		if jugador != null:
			if jugador.has_method("set_can_move"):
				jugador.set_can_move(true)
			elif "can_move" in jugador:
				jugador.can_move = true
				jugador.show_timer()
			$Control.visible = false
	)

func _input(event: InputEvent) -> void:
	#TODO hacer que no detecte los inputs del inicio de la animacion
	if ya_mostrado and event is InputEventKey and !ya_terminado:
		if event.is_pressed():
			pushed = true
		elif event.is_released():
			pushed = false
			actual_time = 0
		

func _process(delta: float) -> void:
	if pushed:
		actual_time += delta
		if actual_time >= push_time and !ya_terminado:
			ya_terminado = true
			sacar_zoom(cam_original, cam_temporal, player)
