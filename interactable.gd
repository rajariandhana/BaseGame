extends CollisionObject3D
class_name Interactable

@export var hover_message: String
# Key is input map, Value is default description
@export var interactions: Dictionary[String, String]

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

func get_action_key_name(action) -> String:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			return event.as_text_physical_keycode()
			break
		elif event is InputEventMouseButton:
			return mouse_button_to_text(event.button_index)
	return ""

func get_prompt():
	var lines := []
	if hover_message:
		lines.append(hover_message)
	else:
		lines.append(name)
	for action in interactions.keys():
		var msg = "[" + get_action_key_name(action) + "] " + interactions[action]
		lines.append(msg)
	return "\n".join(lines)

func interact(action: String, body):
	print("Action:", action, "on", name)

func hover_enter(body):
	pass
func hover_exit(body):
	pass
