extends Interactable
class_name Talkable

# display_name will be the this Talkable's 'Character' name
@export var lines: DialogueLines
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()
	reset()
	
func interact(action: Inputs.Keys, body: Node) -> void:
	match action:
		Inputs.Keys.E:
			GameManager.get_player().dialogue_panel.begin(self)

func reset() -> void:
	interactions[Inputs.Keys.E] = "Talk"

# scripts that inherits Talkable can declare the next line to go to
# after getting a respond from player
# TODO: consider changing answer to anything not always String, when it is MCQ
# caller should pass the index of the option, more secure?
func respond(index: int, answer: String) -> int:
	print("Q:", lines.lines[index].text)
	print("A:", answer)
	return index

func get_line(index: int) -> String:
	return lines.lines[index].text

# e.g. modify the next dialogue after a prompting a name from the player
func set_line(index: int, new_dialogue: String) -> void:
	lines.lines[index].text = new_dialogue
