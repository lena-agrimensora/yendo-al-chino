extends RigidBody3D

var inventory_size: int = 10
var items = []

@onready var lista_manager = get_node("/root/Main/list_manager")

@onready var target_rot: Vector3

var agarrado: bool = false

@export var enderezar_timer: float

func agarrar() -> void:
	agarrado = true
	collision_layer = 1 << 2
	enderezar()
	apagar_luz()

func soltar() -> void:
	agarrado = false
	collision_layer = 1 << 0

func enderezar() -> void:
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "rotation:x", 0, enderezar_timer)
	tween.parallel().tween_property(self, "rotation:z", 0, enderezar_timer)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("agarrar"):
		if body.get_script().get_path() == "res://ESCENAS/Productos/Producto.gd":
			if _add_item(body):
				body.meter_a_carrito(self)
				if lista_manager.check_mandado(body) != -1:
					lista_manager.tachar(lista_manager.check_mandado(body))
			else:
				if body.has_method("rechazar_entrada"):
					body.rechazar_entrada()

func _add_item(item) -> bool:
	if items.size() < inventory_size:
		items.append(item)
		return true
	return false

func _remove_item(item_to_remove) -> void:
	if items.has(item_to_remove):
		if lista_manager.check_mandado(item_to_remove) != -1:
					lista_manager.destachar(lista_manager.check_mandado(item_to_remove))
		items.erase(item_to_remove)

func _process(_delta: float) -> void:
	if !items.is_empty():
		for i in items.size():
			var item = items[i]
			var slot_position = $Inventario.get_child(i).global_position
			item.global_position = slot_position
			var frente = -global_transform.basis.z
			var hacia_arriba = Vector3.UP * 1
			var direccion = (frente + hacia_arriba).normalized()
			item.look_at(item.global_position + direccion, global_transform.basis.y)

func get_inventory():
	return items


#TODO hacer mas lindo :v
func apagar_luz() -> void:
	$OmniLight3D.visible = false
