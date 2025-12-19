extends Interactable
class_name Box

@onready var mesh_instance_3d: MeshInstance3D = $"./MeshInstance3D"

@export var color_primary: String
@export var color_secondary: String

var toggle: bool = false
var current_color: String

func _ready() -> void:
	current_color = color_primary
	set_overlay_color(current_color)
	toggle = false

func set_overlay_color(color: Color):
	var mat := mesh_instance_3d.material_overlay

	if mat == null:
		mat = StandardMaterial3D.new()
		mesh_instance_3d.material_overlay = mat
	else:
		mat = mat.duplicate()
	mesh_instance_3d.material_overlay = mat
	mat.albedo_color = color

func interact(action, body) -> void:
	toggle = !toggle
	if toggle:
		set_overlay_color(color_secondary)
		current_color = color_secondary
	else:
		set_overlay_color(color_primary)
		current_color = color_primary

func hover_enter(body) -> void:
	var dimmed_color = Color(current_color) * 0.5
	set_overlay_color(dimmed_color)

func hover_exit(body) -> void:
	set_overlay_color(current_color)
