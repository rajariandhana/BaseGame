extends Interactable
class_name Talkable

# display_name will be the this Talkable's 'Character' name
@export var dialogue: Array[String]
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal dialogue_requested(talkable: Talkable)

func _ready() -> void:
	reset()
	
func interact(action: Inputs.Keys, body: Node) -> void:
	match action:
		Inputs.Keys.E:
			if GameManager.get_player().is_talking == false:
				begin_dialogue()

func begin_dialogue() -> void:
	interactions[Inputs.Keys.E] = ""
	dialogue_requested.emit(self)

func end_dialogue() -> void:
	reset()

func reset() -> void:
	interactions[Inputs.Keys.E] = "Talk"
