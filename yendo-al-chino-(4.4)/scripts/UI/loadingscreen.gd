extends Control
class_name LoadingScreen

@onready var progress_bar = %ProgressBar
var main_scene_path: String = 'res://scenes/main.tscn'
var progress_value := 0.0

func _ready() -> void:
	ResourceLoader.load_threaded_request(main_scene_path)	

func _process(delta: float):
	if not main_scene_path:
		return

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(main_scene_path, progress)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		progress_value = progress[0] * 100
		progress_bar.value = move_toward(progress_bar.value, progress_value, delta * 20)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		
		progress_bar.value = move_toward(progress_bar.value, 100.0, delta * 150)

		
		if progress_bar.value == 100.0:
			var packed_scene = ResourceLoader.load_threaded_get(main_scene_path)
			get_tree().change_scene_to_packed(packed_scene)
