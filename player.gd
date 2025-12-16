extends CharacterBody3D

const MOUSE_SPEED_X: float = 0.2
const MOUSE_SPEED_Y: float = 0.3

const SPEED = 5.5 # 5.5 meter/second

const RAY_LENGTH: float = 1000.0

@onready var camera_3d: Camera3D = %Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var space_state = get_world_3d().direct_space_state

@onready var interact_ray: RayCast3D = $Camera3D/InteractRay
@onready var hover_message: Label = $CanvasLayer/HoverMessage

var interacting: Node = null

func _ready() -> void:
	#return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	#return
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

func get_aim_target():
	var origin = camera_3d.global_transform.origin
	var direction = -camera_3d.global_transform.basis.z
	
	var query = PhysicsRayQueryParameters3D.create(
		origin,
		origin + direction * RAY_LENGTH
	)
	query.exclude = [self]
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	return result

func _process(delta):
	var hit = get_aim_target()
	if hit and hit.collider.is_in_group("interactable"):
		var n := hit.collider as Area3D
		var current = n.interact_root.get_interact()
		if current != interacting:
			interacting = current
			n.interact_root.interact()
	else:
		interacting = null

func ray():
	hover_message.text = ""
	if interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		if collider is Interactable:
			hover_message.text = collider.get_prompt()
			if Input.is_action_just_pressed(collider.interact_key):
				collider.interact(owner)

func _physics_process(delta: float) -> void:
	ray()
	
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
