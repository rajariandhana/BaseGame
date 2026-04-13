extends CanvasLayer

@export var moveable_state: State

func _ready() -> void:
	close()

func open() -> void:
	visible = true

func close() -> void:
	visible = false

func _on_button_resume_pressed() -> void:
	GameManager.get_player().state_machine.change_state(moveable_state)

func _on_button_main_menu_pressed() -> void:
	GameManager.change_scene(Scenes.main_menu_scene)
