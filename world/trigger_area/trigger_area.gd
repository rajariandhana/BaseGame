extends Area3D
class_name TriggerArea

@onready var handler: Node = $Handler;

func _on_body_entered(body: Node3D) -> void:
	# pass
	# print("_on_body_entered")
	if body is CharacterBody3D and body is Player:
		handle(body);
		# if handler and handler.has_method("handle"):
				# handler.handle(body);

func handle(player: Player) -> void:
	pass

func _on_body_exited(body: Node3D) -> void:
	pass
	# print("_on_body_exited")
