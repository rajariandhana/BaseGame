extends Interactable
class_name Box

@onready var mesh_instance_3d: MeshInstance3D = $"./MeshInstance3D"

@export var color_primary: String
@export var color_secondary: String

var toggle: bool = false
var current_color: String

func setup_ready() -> void:
	current_color = color_primary
	Utils.set_overlay_color(current_color, mesh_instance_3d)
	toggle = false

func interact(action, body) -> void:
	toggle = !toggle
	if toggle:
		Utils.set_overlay_color(color_secondary, mesh_instance_3d)
		current_color = color_secondary
	else:
		Utils.set_overlay_color(color_primary, mesh_instance_3d)
		current_color = color_primary

func hover_enter(body) -> void:
	var dimmed_color = Color(current_color) * 0.5
	Utils.set_overlay_color(dimmed_color, mesh_instance_3d)

func hover_exit(body) -> void:
	Utils.set_overlay_color(current_color, mesh_instance_3d)
