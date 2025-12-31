extends PanelContainer
class_name Storage

@export var storage_name: String
@export var MAX_SIZE: int

@onready var item_slots: VBoxContainer = $VBoxContainer/ScrollContainer/ItemSlots
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
	return item_slots.get_child_count()

func insert(item_data: ItemData) -> void:
	if size() >= MAX_SIZE:
		return
	var new_slot_scene: ItemSlot = item_slot_scene.instantiate()
	item_slots.add_child(new_slot_scene)
	new_slot_scene.fill(item_data)
	new_slot_scene.connect_actions(on_equip_storage, on_drop_storage)

func remove(item_data: ItemData) -> void:
	for item_slot: ItemSlot in item_slots.get_children():
		if item_slot.item_data == item_data:
			item_slot.queue_free()
			return
