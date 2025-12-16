extends CollisionObject3D
class_name Interactable

@export var hover_message: String
@export var interact_key: String = "interact_e"

func mouse_button_to_text(button: int) -> String:
	match button:
		MOUSE_BUTTON_LEFT:
			return "LMB"
		MOUSE_BUTTON_RIGHT:
			return "RMB"
		MOUSE_BUTTON_MIDDLE:
			return "MMB"
		MOUSE_BUTTON_WHEEL_UP:
			return "Wheel Up"
		MOUSE_BUTTON_WHEEL_DOWN:
			return "Wheel Down"
		_:
			return "Mouse %d" % button

func get_prompt():
	var key_name = ""
	for event in InputMap.action_get_events(interact_key):
		if event is InputEventKey:
			key_name = event.as_text_physical_keycode()
			break
		elif event is InputEventMouseButton:
			key_name = mouse_button_to_text(event.button_index)
			break
	var result: String = ""
	if hover_message:
		result += hover_message
	else:
		result += "I am " + name
	result += "\n[" + key_name + "]"
	return result

func interact(body):
	print("Interacting with " + name)
