extends OmniLight3D

@export var min_energy: float = 0.5
@export var max_energy: float = 2.0
@export var transition_time: float = 0.8
@export var hold_time_max: float = 1.0
@export var hold_time_min: float = 3.0
@export var wait_between_loops_min: float = 1.0
@export var wait_between_loops_max: float = 4.0

enum State { RISING, HOLD_MAX, FALLING, HOLD_MIN, WAIT_BEFORE_NEXT }
var state: State = State.RISING

var timer := 0.0
var wait_time := 0.0

func _ready():
	randomize()

func _process(delta):
	timer += delta

	match state:
		State.RISING:
			var t = clamp(timer / transition_time, 0.0, 1.0)
			light_energy = lerp(min_energy, max_energy, t)
			if t >= 1.0:
				timer = 0.0
				state = State.HOLD_MAX

		State.HOLD_MAX:
			light_energy = max_energy
			if timer >= hold_time_max:
				timer = 0.0
				state = State.FALLING

		State.FALLING:
			var t = clamp(timer / transition_time, 0.0, 1.0)
			light_energy = lerp(max_energy, min_energy, t)
			if t >= 1.0:
				timer = 0.0
				state = State.HOLD_MIN

		State.HOLD_MIN:
			light_energy = min_energy
			if timer >= hold_time_min:
				timer = 0.0
				wait_time = randf_range(wait_between_loops_min, wait_between_loops_max)
				state = State.WAIT_BEFORE_NEXT

		State.WAIT_BEFORE_NEXT:
			light_energy = min_energy
			if timer >= wait_time:
				timer = 0.0
				state = State.RISING
