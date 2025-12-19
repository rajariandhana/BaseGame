extends Interactable
class_name Door

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var is_open: bool = false
var is_locked: bool = false

func interact(action, body):
	if action == "interact_e":
		toggle_open()
	elif action == "interact_f":
		toggle_lock()

func toggle_lock():
	is_locked = !is_locked
	if is_locked:
		interactions["interact_f"] = "Unlock"
	else:
		interactions["interact_f"] = "Lock"

func toggle_open():
	if is_locked:
		return
	if !is_open:
		is_open = true
		animation_player.play("door_open")
		interactions["interact_e"] = "Close"
		await animation_player.animation_finished
	else:
		animation_player.play_backwards("door_open")
		await animation_player.animation_finished
		is_open = false
		interactions["interact_e"] = "Open"
