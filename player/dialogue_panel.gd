extends CanvasLayer
class_name DialoguePanel

var is_talking: bool = false
var current_talkable: Talkable
var dialogue_ctr: int = 0
# var dialogue: Array[String]
@onready var name_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NameSlot
@onready var dialogue_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DialogueSlot
@onready var next_key: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextKey
@onready var options_slot: VBoxContainer = $OptionsSlot

signal dialogue_finished

var animation_player: AnimationPlayer;

func begin_dialogue(talkable: Talkable) -> void:
	is_talking = true
	current_talkable = talkable
	dialogue_ctr = 0
	name_slot.text = talkable.display_name
	options_slot.visible = true
	if current_talkable.animation_player:
		animation_player = current_talkable.animation_player;
		next_dialogue()

func next_dialogue() -> void:
	# print("dialogue_ctr: ",dialogue_ctr, "/", current_talkable.lines.lines.size())
	if dialogue_ctr >= current_talkable.lines.lines.size():
		is_talking = false
		dialogue_finished.emit()
		return
	var line: DialogueLine = current_talkable.lines.lines[dialogue_ctr]
	dialogue_slot.text = line.text
	# print("new dialogue_ctr:", dialogue_ctr)
	var type: DialogueType.Types = line.type
	dialogue_ctr += 1
	if type == DialogueType.Types.QuestionChoice:
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

func end_dialogue() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if animation_player:
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play("RESET")
	current_talkable.end_dialogue()
	current_talkable = null
	is_talking = false
	options_slot.visible = true

func action_pressed(to_check: Array) -> bool:
	for check in to_check:
		if Input.is_action_just_pressed(Utils.input_map_value(check)):
			return true
	return false

func _process(delta: float) -> void:
	if is_talking:
		if options_slot.visible:
			return
		if action_pressed([Inputs.Keys.E]):
			next_dialogue()

func _on_answer_option(x) -> void:
	var next_dialogue_index: int = current_talkable.respond(dialogue_ctr - 1, x)
	dialogue_ctr = next_dialogue_index
	next_dialogue()
