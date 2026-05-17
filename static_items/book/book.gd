extends Interactable
class_name Book

@export var custom_height: float = 0.0
@export var custom_color: String = ""

@export var pullable: bool = true
@export var pull_effect: Node

@onready var visual: Interactable = $Visual
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_pulled: bool

func _ready() -> void:
	super()
	visual.setup(display_name, pullable, custom_height, custom_color, animation_player, interactions, pull_effect)
	visual = get_node("Visual")
