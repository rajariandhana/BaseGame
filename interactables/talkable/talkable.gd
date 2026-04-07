extends Interactable
class_name Talkable

# display_name will be the this Talkable's 'Character' name
@export var lines: DialogueLines
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	reset()
	
func interact(action: Inputs.Keys, body: Node) -> void:
	match action:
		Inputs.Keys.E:
			GameManager.get_player().dialogue_panel.begin(self)

func reset() -> void:
	interactions[Inputs.Keys.E] = "Talk"

# scripts that inherits Talkable can declare the next line to go to
# after getting a respond from player
func respond(index: int, answer: String) -> int:
	print("Q:", lines.lines[index].text)
	print("A:", answer)
	return index
