extends Node

var ENV: String = "prod"

func _ready() -> void:
	ENV = _detect_env()
	print("Se seteó el ambiente:  ", ENV)

func _detect_env() -> String:
	
	var proj_env = get_env_from_project_settings()
	if proj_env != "":
		return proj_env
	return "dev"


func get_env_from_project_settings() -> String:
	if ProjectSettings.has_setting("custom/env"):
		return str(ProjectSettings.get_setting("custom/env")).strip_edges().to_lower()
	return ""


func is_dev() -> bool: return ENV == "dev"
func is_test() -> bool: return ENV == "test"
func is_prod() -> bool: return ENV == "prod"
func current() -> String: return ENV
