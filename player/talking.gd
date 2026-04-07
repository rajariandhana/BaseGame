extends State

@export var moveable_state: State

var dialogue_panel: DialoguePanel

func enter() -> void:
  super()
  dialogue_panel = parent.dialogue_panel
  dialogue_panel.open()
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func exit() -> void:
  dialogue_panel.close()

func process_physics(delta: float) -> State:

  if Utils.action_pressed([Inputs.Keys.E]) and dialogue_panel.waiting_response == false:
    dialogue_panel.next()
  return null