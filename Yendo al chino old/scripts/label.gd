extends Label

var list_text: String = " Lista de compras:\n"

@onready var tachones =  $"../VBoxContainer".get_children()

@onready var lista = get_node("/root/Main/list_manager").get_mandados()

func _ready():
	await get_tree().create_timer(.1).timeout
	for mandado in lista:
		list_text += "- " + mandado.instantiate().name + "\n"
	text = list_text
	get_node("/root/Main/list_manager").set_lista(self)

func tachar(id: int) -> void:
	tachones[id].modulate = Color(1.0, 1.0, 1.0)

func destachar(id: int) -> void:
	tachones[id].modulate = Color(1.0, 1.0, 1.0, 0.0)
