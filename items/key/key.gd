extends Item

# maybe make it into a list so key can open more doors? vice versa
@export var door_id: String

# func _ready() -> void:
# 	interactions[Inputs.Keys.USE_PRIMARY] = "Lock / Unlock"

func use_primary_on_object(door: Interactable):
	if door is Door or door is DoorHinge:
		door.toggle_lock(door_id);
