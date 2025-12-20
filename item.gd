extends Interactable
class_name Item

signal request_pickup(item: Node3D)

func _init() -> void:
	interactions[Inputs.Keys.E] = "Pickup"

func interact(action, body):
	if action == Inputs.Keys.E:
		print("Picking up ", name)
		emit_signal("request_pickup", self)
