extends State

func enter() -> void:
	# print("DP.State.WaitNext")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	parent.next_key.visible = true

func exit() -> void:
	parent.next_key.visible = false

func process_physics(_delta: float) -> State:
	if Utils.action_pressed([Inputs.Keys.E]):
		# print("Utils.action_pressed([Inputs.Keys.E])")
		return parent.next_printing()
	return null