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
@onready var dark_layer: ColorRect = $DarkLayer

var animation_player: AnimationPlayer;

@export var moveable: State

@onready var state_machine: StateMachine = $StateMachine
@export var printing_state: State
@export var wait_next_state: State
@export var wait_mcq_state: State
@export var wait_oeq_state: State
@export var idle_state: State

var current_line: DialogueLine = null

# TODO: could put another state machine in dialogue_panel, maybe later
# e.g. while waiting for player respond

func _ready() -> void:
	next_key.visible = false
	mcq_slot.visible = false
	oeq_slot.visible = false

	state_machine.set_process(false)
	state_machine.init(self)

func begin(talkable: Talkable) -> void:
	# print("dialogue_panel.begin()")
	current_talkable = talkable
	dialogue_ctr = 0
	name_slot.text = talkable.display_name
	next_printing()

func open() -> void:
	visible = true
	state_machine.change_state(printing_state)
	state_machine.set_process(true)

func close() -> void:
	if animation_player:
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play("RESET")
	animation_player = null

	state_machine.set_process(false)
	state_machine.change_state(printing_state)
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func next_printing() -> void:
	if dialogue_ctr >= current_talkable.lines.lines.size():
		state_machine.change_state(idle_state)
		end()
		return
	
	current_line = current_talkable.lines.lines[dialogue_ctr]
	
	animation_player = current_talkable.animation_player
	state_machine.change_state(printing_state)
	dialogue_ctr += 1

func wait() -> void:
	var wait_state: State = wait_next_state
	var type: DialogueType.Types = current_line.type
	match type:
		DialogueType.Types.MCQ:
			wait_mcq_state.setup(current_line.answer_choice)
			wait_state = wait_mcq_state
		DialogueType.Types.OEQ:
			wait_state = wait_oeq_state
	state_machine.change_state(wait_state)

func end() -> void:
	# print("dialogue_panel.end()")
	current_talkable = null
	GameManager.get_player().state_machine.change_state(moveable)

func handle_respond(answer: String) -> void:
	dialogue_ctr = current_talkable.respond(dialogue_ctr - 1, answer)
	waiting_response = false
	next_printing()
