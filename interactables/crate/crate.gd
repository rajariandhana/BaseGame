extends Interactable
class_name Crate

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			create_collision_from_mesh(child)

func create_collision_from_mesh(mesh_instance: MeshInstance3D):
	if mesh_instance.mesh == null:
		return

	var collision_shape = CollisionShape3D.new()
	collision_shape.name = mesh_instance.name + "_Collision"
	var shape = mesh_instance.mesh.create_trimesh_shape()
	collision_shape.shape = shape
	collision_shape.transform = mesh_instance.transform
	add_child(collision_shape)

func open():
	print("open crate")
	# TODO: add break animation
	var top = get_node("Top")
	if top:
		top.queue_free()
	var top_collision = get_node("Top_Collision")
	if top_collision:
		top_collision.queue_free()
	
