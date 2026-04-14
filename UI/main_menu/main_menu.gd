extends CanvasLayer

func _on_button_room_0_pressed() -> void:
	GameManager.change_scene(Scenes.room_0_scene)

func _on_button_doors_pressed() -> void:
	GameManager.change_scene(Scenes.doors_scene)


func _on_button_level_0_pressed() -> void:
	GameManager.change_scene(Scenes.level_0_scene)