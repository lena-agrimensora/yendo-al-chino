extends Node

const IN_PRODUCTOS_GLB_PATH: String = "res://ESCENAS/Productos_Lena_Test/Herramientas/Productos GLB/"
const OUT_PRODUCTOS_TSCN_PATH: String = "res://ESCENAS/Productos_Lena_Test/Herramientas/Productos TSCN/"
#Por si se quieren generar escenas con otro sscript? o al pedo no hardcodearlo?
@export var producto_script: Script
@export var collision_offset: int = 0.1

func _ready():
	var dir = DirAccess.open(IN_PRODUCTOS_GLB_PATH)
	if not dir:
		return
	
	dir.list_dir_begin()
	var subcarpeta = dir.get_next()
	while subcarpeta != "":
		if dir.current_is_dir() and subcarpeta != "." and subcarpeta != "..":
			process_folder(subcarpeta)
		subcarpeta = dir.get_next()
	dir.list_dir_end()

func process_folder(subcarpeta: String) -> void:
	var subdir_path = IN_PRODUCTOS_GLB_PATH + subcarpeta + "/"
	var assets = get_glb_and_textures_in_folder(subdir_path)
	
	if not assets.has("glb_path"):
		return
	
	for texture_path in assets["textures"]:
		var texture = load(texture_path)
		if not texture:
			continue
		
		var tex_name = texture.resource_name
		var mesh_instance = create_mesh_instance_from_glb(assets["glb_path"], texture)
		if mesh_instance == null:
			continue
		
		#res://ESCENAS/Productos_Lena_Test/Herramientas/Productos GLB/Aromatizante atom/AROMATIZANTE ATOMIZADOR_aromatizanteAtoMenta_TEX.png
		#Subcarpeta+_+
		
		var rigidbody = create_rigidbody_with_mesh(mesh_instance)
		if producto_script:
			rigidbody.set_script(producto_script)
		
		var rigidbody_with_collision := create_CollisionShape3D_with_RB(rigidbody)
		var base_name = texture_path.get_file().get_basename()
		#Cambiar el base name, formatear un poco el nombre
		#Muchos tienen el _TEX si hay alguna convencion de nomenclatura lo puedo sacar
		#Por ej Lata_Arvejas_TEX -> Lata_Arvejas.tscn
		var finalstring = base_name.split("_")[0]
		var output_path = OUT_PRODUCTOS_TSCN_PATH + subcarpeta + "_" + finalstring + ".tscn"
		#TODO: reempalzar output por subcarpeta?
		pack_and_save_scene(rigidbody_with_collision, output_path)

func get_glb_and_textures_in_folder(path: String) -> Dictionary:
	var result = {
		"glb_path": "",
		"textures": [],
		"name": "", #aca el nombre? de donde pingo lo saco
	}
	
	var dir = DirAccess.open(path)
	if not dir:
		return result
	
	#Asumiento que siempre hay 1 .glb + multiples png para la textura
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file.ends_with(".glb"):
			result["glb_path"] = path + file
		elif file.ends_with(".png"):
			result["textures"].append(path + file)
			var prod_name = file.split("_")[1]
			result["name"] = prod_name
		file = dir.get_next()
	dir.list_dir_end()
	return result

func create_mesh_instance_from_glb(glb_path: String, texture: Texture) -> MeshInstance3D:
	var glb_resource = load(glb_path)
	if not glb_resource:
		print("JIJIJI")
		return null
	
	var glb_instance = glb_resource.instantiate()
	if not glb_instance:
		return null
	
	for node in glb_instance.get_children():
		if node is MeshInstance3D and node.mesh != null:
			var mesh_instance := MeshInstance3D.new()
			mesh_instance.mesh = node.mesh
			var mat := StandardMaterial3D.new()
			mat.albedo_texture = texture
			mesh_instance.material_override = mat
			return mesh_instance
	
	return null

func create_rigidbody_with_mesh(mesh_instance: MeshInstance3D) -> RigidBody3D:
	var body := RigidBody3D.new()
	#TODO: como obtengo un nombre valido?
	body.name = "Test"
	#No es necesario rotar ya que es una herramienta, peero
	mesh_instance.transform = Transform3D.IDENTITY
	body.add_child(mesh_instance)
	#esta linea casi me mata ->
	mesh_instance.owner = body
	return body

func create_CollisionShape3D_with_RB(root: RigidBody3D ) -> RigidBody3D:
	var mesh_ref: MeshInstance3D = null
	for child in root.get_children():
		if child is MeshInstance3D:
			mesh_ref = child
			break
	#debug :#
	var aabb: AABB = mesh_ref.get_aabb()
	var offset: Vector3 = Vector3(collision_offset, collision_offset, collision_offset)
	
	var cshape = CollisionShape3D.new()
	var boxshape = BoxShape3D.new()
	boxshape.size = aabb.size + offset * 2.0 
	cshape.shape = boxshape
	
	cshape.transform.origin = aabb.position + aabb.size / 2.0
	root.add_child(cshape)
	cshape.owner = root
	
	return root

func pack_and_save_scene(root: Node, output_path: String) -> void:
	var packed_scene = PackedScene.new()
	var pack_result = packed_scene.pack(root)
	if pack_result != OK:
		return
	
	var error = ResourceSaver.save(packed_scene, output_path)
	if error == OK:
		print("Listo!! guardado en " + output_path)
	else:
		push_error("Error guardando escena :( ")
		pass
