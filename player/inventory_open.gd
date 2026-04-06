extends State

@export var moveable_state: State

func enter() -> void:
  super()
  parent.inventory.open()
  # does that mean enter is enable movement keys

func exit() -> void:
  parent.inventory.close()
  # disable movement keys?

func process_physics(_delta: float) -> State:
  if Utils.action_pressed([Inputs.Keys.OPEN_INVENTORY]):
    return moveable_state
  return null