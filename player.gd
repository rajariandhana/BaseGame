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

@onready var hand: Node3D = $Camera3D/Hand

var interacting: Interactable = null

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

func action_pressed(to_check: Array) -> bool:
	for check in to_check:
		if Input.is_action_just_pressed(Utils.input_map_value(check)):
			return true
	return false

func handle_equipped() -> void:
	var item: Item = get_equipped()
	if item == null:
		return
	var target = interact_ray.get_collider()
	if action_pressed([Inputs.Keys.USE_PRIMARY]):
		item.use(Inputs.Keys.USE_PRIMARY, target)
	elif action_pressed([Inputs.Keys.USE_SECONDARY]):
		item.use(Inputs.Keys.USE_SECONDARY, target)

func switch_hover(new_target: Interactable):
	if interacting:
		interacting.hover_exit(owner)
	interacting = new_target
	interacting.hover_enter(owner)
	
	if interacting is Item and not interacting.request_equip.is_connected(pickup):
		interacting.request_equip.connect(pickup)

func clear_hover():
	if interacting:
		interacting.hover_exit(owner)
		interacting = null

func handle_interactable(collider: Interactable):
	if interacting != collider:
		switch_hover(collider)
	
	hover_message.text = collider.get_prompt()
	for action in collider.interactions.keys():
		if action_pressed([action]):
			collider.interact(action, owner)

func handle_interaction():
	var collider = interact_ray.get_collider()

	if collider is Interactable:
		handle_interactable(collider)
		return
	if action_pressed([Inputs.Keys.DROP]) and collider.is_in_group("ItemZone"):
		drop(interact_ray.get_collision_point())

func ray():
	hover_message.text = ""
	
	if interact_ray.is_colliding():
		handle_interaction()
	else:
		clear_hover()
	if is_equipped():
		handle_equipped()

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

func pickup(item: Node3D):
	if is_equipped():
		return
	set_item(item, true)
	item.reparent(hand)
	item.transform = Transform3D.IDENTITY

func drop(drop_position: Vector3):
	if !is_equipped():
		return
	var item := get_equipped()
	var world_items := get_parent()
	item.reparent(world_items)
	item.global_position = drop_position
	#item.rotation_degrees = Vector3.ZERO
	set_item(item, false)

func set_item(item: Node3D, status: bool):
	if item is RigidBody3D:
		item.freeze = status
	var shape:= item.get_node_or_null("CollisionShape3D")
	if shape:
		shape.disabled = status

#func swap(new_item: Node3D, drop_position: Vector3):

func is_equipped() -> bool:
	if hand.get_child_count() == 0:
		return false
	return true

# requires hand not empty
func get_equipped() -> Item:
	var item := hand.get_child(0)
	if item is Item:
		return item
	return null
