extends CharacterBody3D

const MOUSE_SPEED_X: float = 0.2
const MOUSE_SPEED_Y: float = 0.3

const SPEED = 5.5 # 5.5 meter/second

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	#print(event)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SPEED_Y
		%Camera3D.rotation_degrees.x -= event.relative.y * MOUSE_SPEED_X
		%Camera3D.rotation_degrees.x = clamp(
			%Camera3D.rotation_degrees.x,
			-60.0,
			60.0
		)

func _physics_process(delta: float) -> void:
	var input_direction_2D = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)
	var input_direction_3D = Vector3(
		input_direction_2D.x,
		0.0,
		input_direction_2D.y
	)
	var direction = transform.basis * input_direction_3D
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	velocity.y -= 20.0 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 10.0
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0
	
	move_and_slide()
