extends Item

@export var color: String
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	Utils.set_overlay_color(color, mesh_instance_3d)
