extends Node

var player: Player

func set_player(in_player:Player) -> void:
	player = in_player

func get_player() -> Player:
	return player

func change_scene(scene: String) -> void:
	# print("change_scene", scene)
	get_tree().change_scene_to_file(scene)
