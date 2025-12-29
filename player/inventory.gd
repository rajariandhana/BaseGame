extends CenterContainer
class_name Inventory

@onready var equipped_slots: VBoxContainer = $MarginContainer/VBoxContainer/Equipped/VBoxContainer/EquippedSlots
@onready var storage: PanelContainer = $MarginContainer/VBoxContainer/Storage

@onready var item_slot_scene: PackedScene = preload("res://storage/item_slot.tscn")
var equipped_slot: ItemSlot

func _ready() -> void:
	storage.open()
	close()

func open() -> void:
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pickup(item: Item):
	storage.insert(item)

func equip(item: Item):
	equipped_slot = item_slot_scene.instantiate()
	equipped_slots.add_child(equipped_slot)
	var item_data: ItemData = ItemDB.get_item(item.item_ID)
	equipped_slot.fill(item_data)
	equipped_slot.toggle_equip_button(false)

func drop_equipped():
	equipped_slot.queue_free()

func drop():
	pass
