extends StaticBody3D

func _ready() -> void:
	for child: Node in get_children():
		if child is MeshInstance3D:
			Utils.create_collision_from_mesh(self, child)
