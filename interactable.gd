extends CollisionObject3D
class_name Interactable

@export var my_name: String
@export var hover_message: String
# Key is input map, Value is default description
@export var interactions: Dictionary[Inputs.Keys, String]

# child must not use built in _init() and or _ready()
# use _init_interactable() _ready_interactable() instead
func _init() -> void:
	_init_interactable()
func _ready() -> void:
	if my_name == null or my_name == "":
		my_name = name
	#print(my_name)
	_ready_interactable()
func _init_interactable() -> void:
	pass
func _ready_interactable() -> void:
	pass

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
		lines.append(my_name)
	for input_key in interactions.keys():
		var input_value = Utils.input_map_value(input_key)
		var msg = "[" + get_action_key_name(input_value) + "] " + interactions[input_key]
		lines.append(msg)
	return "\n".join(lines)

func interact(action: Inputs.Keys, body):
	print(Utils.input_map_value(action), " on ", name)

func hover_enter(body):
	pass
func hover_exit(body):
	pass
