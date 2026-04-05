extends State

@export var moveable_state: State
@export var talking_state: State

func enter() -> void:
  super()
  parent.inventory.open()
  parent.cross_hair.visible = false
  parent.dark_layer.visible = true
  parent.hover_message.text = ""
  # does that mean enter is enable movement keys

func exit() -> void:
  parent.inventory.close()
  parent.cross_hair.visible = true
  parent.dark_layer.visible = false
  parent.hover_message.text = ""
  # disable movement keys?

func process_physics(_delta: float) -> State:
  if Utils.action_pressed([Inputs.Keys.OPEN_INVENTORY]):
    return moveable_state
  return null