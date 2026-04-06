extends State

@export var inventory_open_state: State
@export var talking_state: State
@export var menu_open_state: State

const SPEED: float = 5.5 # 5.5 meter/second

const MOUSE_SPEED_X: float = 0.2
const MOUSE_SPEED_Y: float = 0.3

func enter() -> void:
  super()
  parent.cross_hair.visible = true
  parent.hover_message.text = ""
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  # does that mean enter is enable movement keys

func exit() -> void:
  parent.cross_hair.visible = false
  parent.hover_message.text = ""
  # disable movement keys?
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  
func process_physics(delta: float) -> State:

  if Utils.action_pressed([Inputs.Keys.OPEN_INVENTORY]):
    return inventory_open_state
  handle_move(delta)
  var res: State = parent.interact_ray.scan()
  if res:
    return res
  return null

func handle_move(delta: float) -> void:
  var input_direction_2D: Vector2 = Input.get_vector(
    "move_left",
    "move_right",
    "move_forward",
    "move_back"
  )
  var input_direction_3D: Vector3 = Vector3(
    input_direction_2D.x,
    0.0,
    input_direction_2D.y
  )
  var direction: Vector3 = parent.transform.basis * input_direction_3D
  parent.velocity.x = direction.x * SPEED
  parent.velocity.z = direction.z * SPEED

  parent.velocity.y -= 20.0 * delta
  if Input.is_action_just_pressed("jump") and parent.is_on_floor():
    parent.velocity.y = 10.0
  elif Input.is_action_just_released("jump") and parent.velocity.y > 0.0:
    parent.velocity.y = 0

  parent.move_and_slide()

func process_input(event: InputEvent) -> State:
  if event.is_action_pressed("ui_cancel"):
    return menu_open_state
    # go to pause menu, should it be a state or not?
    # cause pause should affect everything to pause, not just the player
  elif event is InputEventMouseMotion:
    handle_mouse_direction(event)
  return null

func handle_mouse_direction(event: InputEventMouseMotion) -> void:
  parent.rotation_degrees.y -= event.relative.x * MOUSE_SPEED_Y
  parent.camera_3d.rotation_degrees.x -= event.relative.y * MOUSE_SPEED_X
  parent.camera_3d.rotation_degrees.x = clamp(
    parent.camera_3d.rotation_degrees.x,
    -60.0,
    60.0
  )