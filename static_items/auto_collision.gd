extends StaticBody3D

func auto_collision(mesh_instance: MeshInstance3D) -> CollisionShape3D:
	var aabb: AABB = mesh_instance.mesh.get_aabb()

	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	var shape: BoxShape3D = BoxShape3D.new()
	shape.size = aabb.size

	collision_shape.shape = shape

	collision_shape.position = aabb.position + aabb.size * 0.5

	collision_shape.transform = mesh_instance.transform
	return collision_shape

func _ready() -> void:
	for child: Node in get_children():
		if child is MeshInstance3D:
			var collision: CollisionShape3D = auto_collision(child)
			add_child(collision)