extends Interactable
class_name Door

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var is_open: bool = false

func interact(body):
	toggle()

func toggle():
	if !is_open:
		animation_player.play("door_open")
	else:
		animation_player.play_backwards("door_open")
	is_open = !is_open
