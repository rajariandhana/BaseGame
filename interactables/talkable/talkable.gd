extends Interactable
class_name Talkable

# display_name will be the this Talkable's 'Character' name
@export var dialogue: Array[String]

func _ready() -> void:
	reset()
	
func interact(action: Inputs.Keys, body: Node) -> void:
	match action:
		Inputs.Keys.E:
			if GameManager.get_player().is_talking == false:
				begin_dialogue()

func begin_dialogue() -> void:
	interactions[Inputs.Keys.E] = ""
	GameManager.get_player().begin_dialogue(self)

func end_dialogue() -> void:
	reset()

func reset() -> void:
	interactions[Inputs.Keys.E] = "Talk"
