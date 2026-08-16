extends TriggerChangeScene

func handle(player: Player) -> void:
	GameManager.change_scene(Scenes.main_menu_scene);
