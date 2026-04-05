extends CharacterBody3D
class_name Player

const RAY_LENGTH: float = 1000.0

@onready var camera_3d: Camera3D = %Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var space_state = get_world_3d().direct_space_state

@onready var interact_ray: RayCast3D = $Camera3D/InteractRay
@onready var hover_message: Label = $CanvasLayer/HoverMessage
@onready var cross_hair: Label = $CanvasLayer/CrossHair

@onready var hand: Node3D = $Camera3D/Hand

var interacting: Interactable = null

var input_enabled: bool = true
@onready var inventory: Inventory = $CanvasLayer/Inventory
@onready var dark_layer: ColorRect = $CanvasLayer/DarkLayer

# Dialogue
var is_talking: bool = false
# var dialogue: Array[String]
@onready var dialogue_panel: CanvasLayer = $DialoguePanel

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	#return
	GameManager.set_player(self)
	dialogue_panel.visible = false
	dialogue_panel.dialogue_finished.connect(end_dialogue)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if not inventory.request_drop_equipped.is_connected(drop_item_to_world):
		inventory.request_drop_equipped.connect(drop_item_to_world)
	inventory.bind_functions(drop_equipped, equip_from_storage, drop_from_storage)
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func handle_equipped() -> void:
	var item: Item = get_equipped()
	if item == null:
		return
	var target = interact_ray.get_collider()
	if Utils.action_pressed([Inputs.Keys.DROP]):
		drop_equipped(0, null)
	elif Utils.action_pressed([Inputs.Keys.USE_PRIMARY]):
		item.use(Inputs.Keys.USE_PRIMARY, target)
	elif Utils.action_pressed([Inputs.Keys.USE_SECONDARY]):
		item.use(Inputs.Keys.USE_SECONDARY, target)

func switch_hover(new_target: Interactable):
	if interacting:
		if interacting is Talkable:
			interacting.dialogue_requested.disconnect(begin_dialogue)
		interacting.hover_exit(owner)
	interacting = new_target
	interacting.hover_enter(owner)
	
	if interacting is Item:
		if not interacting.request_equip.is_connected(equip):
			interacting.request_equip.connect(equip)
		if not interacting.request_pickup.is_connected(pickup):
			interacting.request_pickup.connect(pickup)
	if interacting is Talkable:
		if not interacting.dialogue_requested.is_connected(begin_dialogue):
			interacting.dialogue_requested.connect(begin_dialogue)

func clear_hover():
	if interacting:
		interacting.hover_exit(owner)
		interacting = null

func handle_interactable(collider: Interactable):
	if interacting != collider:
		switch_hover(collider)
	
	hover_message.text = collider.get_prompt()
	for action in collider.interactions.keys():
		if Utils.action_pressed([action]):
			collider.interact(action, owner)

func handle_interaction():
	var collider = interact_ray.get_collider()

	if collider is Interactable:
		handle_interactable(collider)
		return
	#if Utils.action_pressed([Inputs.Keys.DROP]) and collider.is_in_group("ItemZone"):
		#drop(interact_ray.get_collision_point())



# func _process(delta: float) -> void:
# 	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	if is_talking:
		# if Utils.action_pressed([Inputs.Keys.E]):
			# dialogue_panel.next_dialogue()
		return
	

func equip(item: Item):
	if is_equipped():
		inventory.unequip()
		set_hand(null)
	var item_data: ItemData = ItemDB.get_item(item.item_ID)
	inventory.equip(item_data)
	set_hand(item)

func set_hand(item: Item):
	if item == null:
		var equipped: Item = get_equipped()
		equipped.queue_free()
		return
	set_item(item, true)
	item.reparent(hand)
	item.transform = Transform3D.IDENTITY
	#item.position = Vector3.ZERO
	#print("set to ", item.equip_rotation)
	#item.rotation_degrees = item.equip_rotation

func set_item(item: Node3D, status: bool):
	if item is RigidBody3D:
		item.freeze = status
	var shape:= item.get_node_or_null("CollisionShape3D")
	if shape:
		shape.disabled = status

func pickup(item: Item):
	var item_data: ItemData = ItemDB.get_item(item.item_ID)
	inventory.pickup(item_data)
	item.queue_free()

func drop_equipped(slot_ID: int, item_data: ItemData):
	var equipped: Item = get_equipped()
	if !is_equipped():
		return
	inventory.remove_equipped()
	drop_item_to_world(equipped)
	inventory.drop_equipped()

func drop_item_to_world(item: Item):
	#print("drop_item_to_world")
	#if !is_equipped():
		#return
	item.reparent(get_parent())
	item.global_position = hand.global_position
	item.rotation_degrees.x = -45
	set_item(item, false)

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

func equip_from_storage(slot_ID: int, item_data: ItemData):
	#print("equip_from_storage ", item_data.display_name)
	var item: Item = item_data.scene.instantiate()
	add_child(item)
	equip(item)
	inventory.remove_from_storage(slot_ID)

func drop_from_storage(slot_ID: int, item_data: ItemData):
	#print("drop_from_storage ", item_data.display_name)
	var item: Item = item_data.scene.instantiate()
	add_child(item)
	drop_item_to_world(item)
	inventory.remove_from_storage(slot_ID)

# Dialogue
func begin_dialogue(talkable: Talkable) -> void:
	# print("Player.begin_dialogue()")
	cross_hair.visible = false
	hover_message.visible = false
	is_talking = true
	input_enabled = false
	dialogue_panel.visible = true
	dialogue_panel.begin_dialogue(talkable)

func end_dialogue() -> void:
	# print("Player.end_dialogue()")
	cross_hair.visible = true
	hover_message.visible = true
	input_enabled = true
	is_talking = false
	dialogue_panel.end_dialogue()
	dialogue_panel.visible = false
