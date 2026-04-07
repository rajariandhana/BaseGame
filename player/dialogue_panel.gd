extends CanvasLayer
class_name DialoguePanel

var current_talkable: Talkable
var dialogue_ctr: int = 0
var waiting_response: bool = false
@onready var name_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NameSlot
@onready var dialogue_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DialogueSlot
@onready var next_key: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextKey
@onready var options_slot: VBoxContainer = $OptionsSlot

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
	options_slot.visible = true
	if current_talkable.animation_player:
		animation_player = current_talkable.animation_player;
	next()

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
	if type == DialogueType.Types.QuestionChoice:
		waiting_response = true
		# print("DialogueType.Types.QuestionChoice")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		next_key.visible = false
		options_slot.visible = true
		for child: Node in options_slot.get_children():
			child.free()
		for choice: String in line.answer_choice:
			var button: Button = Button.new()
			button.text = choice
			button.pressed.connect(func(): _on_answer_option(choice))
			options_slot.add_child(button)
	elif type == DialogueType.Types.QuestionOpen:
		# print("DialogueType.Types.QuestionOpen")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		next_key.visible = false
		pass
	else:
		options_slot.visible = false
		next_key.visible = true
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
	options_slot.visible = false
	GameManager.get_player().state_machine.change_state(moveable)

func _on_answer_option(x) -> void:
	var next_dialogue_index: int = current_talkable.respond(dialogue_ctr - 1, x)
	dialogue_ctr = next_dialogue_index
	waiting_response = false
	next()
