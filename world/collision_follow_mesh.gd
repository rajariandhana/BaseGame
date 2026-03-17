extends StaticBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _ready():
	if mesh_instance.mesh == null:
		return

	var aabb: AABB = mesh_instance.mesh.get_aabb()

	var collision_shape := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = aabb.size

	collision_shape.shape = shape

	collision_shape.position = aabb.position + aabb.size * 0.5

	collision_shape.transform = mesh_instance.transform

	add_child(collision_shape)
