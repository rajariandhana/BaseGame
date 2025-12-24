extends Node
class_name Util

func input_map_value(key: Inputs.Keys):
	return Inputs.Mapping[key]

func input_map_key(value: String):
	for key in Inputs.Mapping:
		if Inputs.Mapping[key] == value:
			return key

func set_overlay_color(color: Color, mesh: MeshInstance3D):
	var mat := mesh.material_overlay

	if mat == null:
		mat = StandardMaterial3D.new()
		mesh.material_overlay = mat
	else:
		mat = mat.duplicate()
	mesh.material_overlay = mat
	mat.albedo_color = color
