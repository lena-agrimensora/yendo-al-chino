extends Area3D

@onready var lista_manager = get_node("/root/Main/list_manager")

@onready var dialogos = $"../StaticBody3D/Globo de texto"

var mandados: Array
var mandados_instances: Array

func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	mandados = lista_manager.get_mandados()
	for mandado in mandados:
		var instance = mandado.instantiate()
		mandados_instances.append(instance)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Carrito":
		var canasto_inventario = body.get_inventory()
		
		#dialogos
		if canasto_inventario.size() < mandados_instances.size():
			dialogos.mostrar_dialogo(0)
			return
		elif canasto_inventario.size() > mandados_instances.size():
			dialogos.mostrar_dialogo(1)
			return
		
		
		var mandados_nombres = mandados_instances.map(func(m): return m.name)
		var inventario_nombres = canasto_inventario.map(func(p): return p.name)
		mandados_nombres.sort()
		inventario_nombres.sort()
		if mandados_nombres == inventario_nombres:
			ganar()
		else:
			dialogos.mostrar_dialogo(0)

func check_mandado(mandado, inventario) -> bool:
	for producto in inventario:
		print("lista:" + producto.name)
		print("producto:" + mandado.name)
		if producto.name == mandado.name:
			return true
	return false

func ganar():
	call_deferred("_cambiar_a_victoria")
	
func _cambiar_a_victoria():
	get_tree().change_scene_to_file("res://ESCENAS/UI/Victoria.tscn")
