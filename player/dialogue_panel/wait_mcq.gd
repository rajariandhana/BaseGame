extends State

@export var slot: VBoxContainer

func enter() -> void:
	# print("DP.State.WaitMCQ")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	slot.visible = true
	parent.dark_layer.visible = true

func exit() -> void:
	slot.visible = false
	parent.dark_layer.visible = false

func handle_mcq(option_text: String) -> void:
	# print("handle_mcq: response: ", option_text)
	parent.handle_respond(option_text)

func setup(choices: Array) -> void:
	for child: Node in slot.get_children():
		child.free()
	for choice: String in choices:
		var button: Button = Button.new()
		button.text = choice
		button.pressed.connect(handle_mcq.bind(choice))
		slot.add_child(button)
