extends Control
class_name ItemSlot

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

func fill(item_data: ItemData):
	self.item_data = item_data
	item_name.text = item_data.display_name
	item_description.text = item_data.description

func _on_mouse_entered() -> void:
	return
	action_v_box_container.visible = true

func _on_mouse_exited() -> void:
	return
	action_v_box_container.visible = false

func _on_button_equip_pressed() -> void:
	print("EQUIP ", item_data.display_name)

func _on_button_drop_pressed() -> void:
	print("DROP ", item_data.display_name)

func toggle_equip_button(status: bool) -> void:
	button_equip.visible = status

func toggle_drop_button(status: bool) -> void:
	button_drop.visible = status
