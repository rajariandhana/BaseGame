extends Resource
class_name DialogueLine

@export var text: String
@export var type: DialogueType.Types = DialogueType.Types.Text
@export var answer_choice: Array[String]