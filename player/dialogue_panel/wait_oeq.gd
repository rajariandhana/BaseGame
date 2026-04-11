extends State

@export var container: MarginContainer
@export var slot: HBoxContainer
@export var input: LineEdit
@export var submit_button: Button

func enter() -> void:
	# print("DP.State.WaitOEQ")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	container.visible = true
	parent.dark_layer.visible = true
	submit_button.set_disabled(true)
	input.text = ""

func exit() -> void:
	container.visible = false
	parent.dark_layer.visible = false

func _on_oe_input_text_changed(new_text: String) -> void:
	if new_text == "":
		submit_button.set_disabled(true)
	else:
		submit_button.set_disabled(false)

func _on_oe_submit_button_pressed() -> void:
	var res: String = input.get_text()
	if res == "":
		return
	parent.handle_respond(res)
