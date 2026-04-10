extends State

func enter() -> void:
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func exit() -> void:
  pass

func process_physics(delta: float) -> State:
  if Utils.action_pressed([Inputs.Keys.E]):
    return parent.next()
  return null