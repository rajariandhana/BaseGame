extends State

var ap: AnimationPlayer;

const PRINTING_TIME: float = 0.5

func enter() -> void:
	# print("DP.State.PrintingState")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	parent.dialogue_slot.text = parent.current_line.text
	if parent.animation_player:
		ap = parent.animation_player
		ap.play("talking")
	# print("timeout_start")
	await get_tree().create_timer(PRINTING_TIME).timeout
	# print("timeout_end")
	parent.wait()

func exit() -> void:
	if ap:
		if ap.is_playing():
			ap.stop()
		ap.play("RESET")
	
	ap = null
