extends Interactable
class_name DoorHinge

@export var door: Door

func _ready() -> void:
	display_name = door.display_name
	hover_message = door.hover_message
	interactions = door.interactions

func interact(action, body):
	if action == Inputs.Keys.E:
		door.toggle_open()

func toggle_lock(key_door_id: String):
	door.toggle_lock(key_door_id)
