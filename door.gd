extends Interactable
class_name Door

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var is_open: bool = false
var is_locked: bool = false

func interact(action, body):
	if action == Inputs.Keys.E:
		toggle_open()
	elif action == Inputs.Keys.F:
		toggle_lock()

func toggle_lock():
	is_locked = !is_locked
	if is_locked:
		interactions[Inputs.Keys.F] = "Unlock"
	else:
		interactions[Inputs.Keys.F] = "Lock"

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
