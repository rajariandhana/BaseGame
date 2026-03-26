extends CanvasLayer
class_name DialoguePanel

var is_talking: bool = false
var current_talkable: Talkable
var dialogue_ctr: int = 0
# var dialogue: Array[String]
@onready var name_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NameSlot
@onready var dialogue_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DialogueSlot

func begin_dialogue(talkable: Talkable) -> void:
  is_talking = true
  current_talkable = talkable
  dialogue_ctr = 0
  name_slot.text = talkable.display_name
  next_dialogue()

func next_dialogue() -> void:
  if dialogue_ctr == current_talkable.dialogue.size():
    GameManager.get_player().end_dialogue()
    return
  dialogue_slot.text = current_talkable.dialogue[dialogue_ctr]
  dialogue_ctr += 1

func end_dialogue() -> void:
  current_talkable.end_dialogue()
  current_talkable = null
  is_talking = false
