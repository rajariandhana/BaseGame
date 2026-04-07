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

@onready var inventory: Inventory = $Inventory
@onready var dark_layer: ColorRect = $CanvasLayer/DarkLayer

# Dialogue
var is_talking: bool = false
# var dialogue: Array[String]
@onready var dialogue_panel: CanvasLayer = $DialoguePanel
@export var moveable: State
@onready var menu: CanvasLayer = $Menu

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	#return
	GameManager.set_player(self)
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

# func _process(delta: float) -> void:
# 	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

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
