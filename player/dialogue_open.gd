extends State

@export var moveable_state: State

func enter() -> void:
  super()
  parent.dialogue_panel.open()

func exit() -> void:
  parent.dialogue_panel.close()