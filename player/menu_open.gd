extends State

@export var moveable_state: State

func enter() -> void:
  super()
  parent.menu.open()

func exit() -> void:
  parent.menu.close()

func process_input(event: InputEvent) -> State:
  if event.is_action_pressed("ui_cancel"):
    return moveable_state
  return null