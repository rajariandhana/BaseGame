extends State

@export var moveable_state: State

@export var dialogue_panel: DialoguePanel

func enter() -> void:
	# print("Player.State.Talking")
	dialogue_panel.open()

func exit() -> void:
	dialogue_panel.close()
