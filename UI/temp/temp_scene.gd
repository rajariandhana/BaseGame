extends CanvasLayer

func _on_button_pressed() -> void:
	GameManager.change_scene(Scenes.main_menu_scene)
