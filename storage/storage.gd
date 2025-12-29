extends CenterContainer

@export var storage_name: String
@export var items: Dictionary[String, ItemData]
@export var MAX_SIZE: int

@onready var item_slots: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/ItemSlots
@onready var title: Label = $PanelContainer/VBoxContainer/Title

@onready var item_slot_scene: PackedScene = preload("res://storage/item_slot.tscn")

func _ready() -> void:
	if storage_name:
		title.text = storage_name
	close()

func open() -> void:
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func size() -> int:
	return items.size()

func insert(item: Item) -> void:
	if size() >= MAX_SIZE:
		return
	var new_slot_scene = item_slot_scene.instantiate()
	item_slots.add_child(new_slot_scene)
	var item_data: ItemData = ItemDB.get_item(item.item_ID)
	new_slot_scene.fill(item_data)
	item.queue_free()
