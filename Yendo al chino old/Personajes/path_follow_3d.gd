extends PathFollow3D

@export var speed: float = 5.0
@export var min_move_duration: float = 1.0
@export var max_move_duration: float = 3.0
@export var min_pause_duration: float = 1.0
@export var max_pause_duration: float = 2.5

var rng := RandomNumberGenerator.new()
var moving := true
var timer := 0.0
var current_duration := 0.0

func _ready():
	rng.randomize()
	start_random_duration()

func _process(delta: float) -> void:
	if moving:
		progress += speed * delta
	
	timer -= delta
	if timer <= 0.0:
		moving = !moving
		start_random_duration()

func start_random_duration():
	if moving:
		current_duration = rng.randf_range(min_move_duration, max_move_duration)
	else:
		current_duration = rng.randf_range(min_pause_duration, max_pause_duration)
	timer = current_duration
