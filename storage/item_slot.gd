extends Control
class_name ItemSlot

signal request_equip(slot_ID: int, item_data: ItemData)
signal request_drop(slot_ID: int, item_data: ItemData)

var slot_ID: int
var item_data: ItemData
@onready var item_name: Label = $MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var item_description: Label = $MarginContainer/HBoxContainer/VBoxContainer/Description

@onready var action_v_box_container: VBoxContainer = $ActionVBoxContainer

@onready var button_equip: Button = $ActionVBoxContainer/ButtonEquip
@onready var button_drop: Button = $ActionVBoxContainer/ButtonDrop

func _ready() -> void:
	return
	action_v_box_container.visible = false

func equip():
	pass
func drop():
	pass

func fill(slot_ID: int, item_data: ItemData):
	#print(item_data.display_name, " on slot ", slot_ID)
	self.slot_ID = slot_ID
	self.item_data = item_data
	item_name.text = item_data.display_name
	item_description.text = item_data.description

func connect_actions(on_equip, on_drop):
	#print("connect_actions ", type_string(typeof(on_equip)), " ", type_string(typeof(on_drop)))
	if on_equip and not self.request_equip.is_connected(on_equip):
			self.request_equip.connect(on_equip)
	if on_drop and not self.request_drop.is_connected(on_drop):
		self.request_drop.connect(on_drop)

func _on_mouse_entered() -> void:
	return
	action_v_box_container.visible = true

func _on_mouse_exited() -> void:
	return
	action_v_box_container.visible = false

func _on_button_equip_pressed() -> void:
	#print("_on_button_equip_pressed")
	request_equip.emit(slot_ID, item_data)

func _on_button_drop_pressed() -> void:
	#print("_on_button_drop_pressed")
	request_drop.emit(slot_ID, item_data)

func toggle_equip_button(status: bool) -> void:
	button_equip.visible = status

func toggle_drop_button(status: bool) -> void:
	button_drop.visible = status
