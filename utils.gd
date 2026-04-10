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

func get_random_color():
	randomize()
	var color = Color(randf(), randf(), randf())
	return color.to_html(false)

func action_pressed(to_check: Array) -> bool:
	for check: int in to_check:
		if Input.is_action_just_pressed(input_map_value(check)):
			return true
	return false

# On usage use `await` if want to wait for the function to end then execute next line
func timeout(seconds: float) -> void:
	# print("timeout_start")
	await get_tree().create_timer(seconds).timeout
	# print("timeout_end")