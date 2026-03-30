extends CanvasLayer
class_name DialoguePanel

var is_talking: bool = false
var current_talkable: Talkable
var dialogue_ctr: int = 0
# var dialogue: Array[String]
@onready var name_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NameSlot
@onready var dialogue_slot: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DialogueSlot

signal dialogue_finished

var animation_player: AnimationPlayer;

func begin_dialogue(talkable: Talkable) -> void:
  is_talking = true
  current_talkable = talkable
  dialogue_ctr = 0
  name_slot.text = talkable.display_name
  if current_talkable.animation_player:
    animation_player = current_talkable.animation_player;
  next_dialogue()

func next_dialogue() -> void:
  if dialogue_ctr == current_talkable.dialogue.size():
    dialogue_finished.emit()
    return
  dialogue_slot.text = current_talkable.dialogue[dialogue_ctr]
  dialogue_ctr += 1
  if animation_player:
    if animation_player.is_playing():
      animation_player.stop()
    animation_player.play("talking")
    await animation_player.animation_finished
    animation_player.play("RESET")

func end_dialogue() -> void:
  if animation_player:
    if animation_player.is_playing():
      animation_player.stop()
    animation_player.play("RESET")
  current_talkable.end_dialogue()
  current_talkable = null
  is_talking = false
