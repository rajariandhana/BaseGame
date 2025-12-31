extends PanelContainer
class_name Storage

@export var storage_name: String
@export var MAX_SIZE: int = 10
# ID - ItemSlot
@export var items: Dictionary[int, ItemSlot]

@onready var item_slot_container: VBoxContainer = $VBoxContainer/ScrollContainer/ItemSlotContainer
@onready var title: Label = $PanelContainer/VBoxContainer/Title

@onready var item_slot_scene: PackedScene = preload("res://storage/item_slot.tscn")

func _ready() -> void:
	if storage_name:
		title.text = storage_name
	close()

var on_equip_storage: Callable
var on_drop_storage: Callable

func bind_functions(on_equip_storage: Callable, on_drop_storage: Callable):
	self.on_equip_storage = on_equip_storage
	self.on_drop_storage = on_drop_storage
 
func open() -> void:
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func size() -> int:
	return item_slot_container.get_child_count()

# requires not full but with verbose check, consider remove checker
func generate_slot_id():
	if size() >= MAX_SIZE:
		return
	for slot_id: int in range(MAX_SIZE):
		if items.has(slot_id) == false:
			return slot_id

func insert(item_data: ItemData) -> void:
	if size() >= MAX_SIZE:
		return
	var new_slot_scene: ItemSlot = item_slot_scene.instantiate()
	var slot_ID = generate_slot_id()
	items[slot_ID] = new_slot_scene
	item_slot_container.add_child(new_slot_scene)
	new_slot_scene.fill(slot_ID, item_data)
	new_slot_scene.connect_actions(on_equip_storage, on_drop_storage)

func remove(slot_ID: int) -> void:
	var item_slot: ItemSlot = items[slot_ID]
	item_slot.queue_free()
