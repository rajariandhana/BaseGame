extends CanvasLayer
class_name DialoguePanel

var current_talkable: Talkable
var dialogue_ctr: int = 0
var waiting_response: bool = false
@onready var name_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NameSlot
@onready var dialogue_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DialogueSlot
@onready var next_key: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextKey
@onready var mcq_slot: VBoxContainer = $MCQSlot
@onready var oeq_slot: VBoxContainer = $OEQSlot
@onready var oe_input: LineEdit = $OEQSlot/OEInput
@onready var oe_submit_button: Button = $OEQSlot/OESubmitButton
@onready var dark_layer: ColorRect = $DarkLayer

var animation_player: AnimationPlayer;

@export var moveable: State

# TODO: could put another state machine in dialogue_panel, maybe later
# e.g. while waiting for player respond

func open() -> void:
	visible = true

func close() -> void:
	visible = false

func begin(talkable: Talkable) -> void:
	current_talkable = talkable
	dialogue_ctr = 0
	name_slot.text = talkable.display_name
	mcq_slot.visible = false
	oeq_slot.visible = false
	if current_talkable.animation_player:
		animation_player = current_talkable.animation_player;
	next()

# TODO: consider to return State
func next() -> void:
	# print("dialogue_ctr: ",dialogue_ctr, "/", current_talkable.lines.lines.size())
	if dialogue_ctr >= current_talkable.lines.lines.size():
		end()
		return
	var line: DialogueLine = current_talkable.lines.lines[dialogue_ctr]
	dialogue_slot.text = line.text
	# print("new dialogue_ctr:", dialogue_ctr)
	var type: DialogueType.Types = line.type
	dialogue_ctr += 1
	if type == DialogueType.Types.MCQ:
		waiting_response = true
		# print("DialogueType.Types.MCQ")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		next_key.visible = false
		mcq_slot.visible = true
		oeq_slot.visible = false
		dark_layer.visible = true
		for child: Node in mcq_slot.get_children():
			child.free()
		for choice: String in line.answer_choice:
			var button: Button = Button.new()
			button.text = choice
			button.pressed.connect(func(): handle_mcq(choice))
			mcq_slot.add_child(button)
	elif type == DialogueType.Types.OEQ:
		waiting_response = true
		# print("DialogueType.Types.OEQ")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		next_key.visible = false
		mcq_slot.visible = false
		oeq_slot.visible = true
		dark_layer.visible = true
		oe_input.text = ""
		pass
	else:
		next_key.visible = true
		mcq_slot.visible = false
		oeq_slot.visible = false
		dark_layer.visible = false
		oe_submit_button.set_disabled(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if animation_player:
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play("talking")
		await animation_player.animation_finished
		animation_player.play("RESET")

func end() -> void:
	# print("dialogue_panel.end()")
	if animation_player:
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play("RESET")
	current_talkable = null
	mcq_slot.visible = false
	GameManager.get_player().state_machine.change_state(moveable)

func handle_respond(answer: String) -> void:
	var next_dialogue_index: int = current_talkable.respond(dialogue_ctr - 1, answer)
	dialogue_ctr = next_dialogue_index
	waiting_response = false
	next()

func handle_mcq(option_text: String) -> void:
	handle_respond(option_text)

func handle_oeq() -> void:
	var res: String = oe_input.get_text()
	if res == "":
		return
	handle_respond(res)

func _on_oe_input_text_changed(new_text: String) -> void:
	# print("_on_oe_input_text_changed: ", new_text)
	if new_text == "":
		oe_submit_button.set_disabled(true)
	else:
		oe_submit_button.set_disabled(false)
