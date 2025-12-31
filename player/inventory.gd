extends CenterContainer
class_name Inventory

# requires only contain <= 1 child
@onready var equipped_slots: VBoxContainer = $MarginContainer/VBoxContainer/Equipped/VBoxContainer/EquippedSlots
@onready var storage: Storage = $MarginContainer/VBoxContainer/Storage

@onready var item_slot_scene: PackedScene = preload("res://storage/item_slot.tscn")
var equipped_slot: ItemSlot
var equipped_data: ItemData

signal request_drop_equipped()

func _ready() -> void:
	storage.open()
	close()

func open() -> void:
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pickup(item_data: ItemData):
	storage.insert(item_data)

func unequip():
	if equipped_slot == null or equipped_data == null:
		return
	pickup(equipped_data)
	remove_equipped()

func equip(item_data: ItemData):
	equipped_data = item_data
	equipped_slot = item_slot_scene.instantiate()
	equipped_slots.add_child(equipped_slot)
	equipped_slot.fill(item_data)
	equipped_slot.connect_actions(null, on_drop_equipped)
	equipped_slot.toggle_equip_button(false)

func drop_equipped():
	equipped_slot.queue_free()

func drop(item_data: ItemData):
	print("DROP ", item_data.display_name)
	request_drop_equipped.emit()

func remove_equipped():
	equipped_data = null
	equipped_slot.queue_free()

func remove_from_storage(item_data: ItemData):
	storage.remove(item_data)

var on_drop_equipped: Callable
var on_equip_storage: Callable
var on_drop_storage: Callable

func bind_functions(on_drop_equipped: Callable, on_equip_storage: Callable, on_drop_storage: Callable):
	self.on_drop_equipped = on_drop_equipped
	self.on_equip_storage = on_equip_storage
	self.on_drop_storage = on_drop_storage
	storage.bind_functions(on_equip_storage, on_drop_storage)
