extends Interactable
class_name Item

signal request_equip(item: Node3D)

var is_equipped: bool = false

func _init() -> void:
	interactions[Inputs.Keys.EQUIP] = "Equip"

func interact(action, body):
	if action == Inputs.Keys.EQUIP:
		print("Equip ", name)
		request_equip.emit(self)

func equip():
	is_equipped = true
