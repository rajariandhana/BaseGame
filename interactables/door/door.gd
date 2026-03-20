extends Interactable
class_name Door

@export var door_id: String
@onready var animation_player: AnimationPlayer = $"./AnimationPlayer"
@export var door_hinge: DoorHinge

var is_open: bool = false
@export var is_locked: bool = false

func _ready() -> void:
	interactions[Inputs.Keys.E] = "Open"
	if is_locked:
		set_hover_message("Door is locked")
		interactions[Inputs.Keys.E] = ""

func interact(action, body):
	if action == Inputs.Keys.E:
		toggle_open()

func set_hover_message(message: String):
	hover_message = message
	door_hinge.hover_message = message

func toggle_lock(key_door_id):
	if key_door_id != door_id || is_open:
		return
	is_locked = !is_locked
	if is_locked:
		set_hover_message("Door is locked")
		interactions[Inputs.Keys.E] = ""
	else:
		set_hover_message("")
		interactions[Inputs.Keys.E] = "Open"

func toggle_open():
	if is_locked:
		return
	if !is_open:
		is_open = true
		animation_player.play("door_open")
		interactions[Inputs.Keys.E] = "Close"
		await animation_player.animation_finished
	else:
		animation_player.play_backwards("door_open")
		await animation_player.animation_finished
		is_open = false
		interactions[Inputs.Keys.E] = "Open"
