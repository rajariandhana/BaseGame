extends Interactable
class_name Crate

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var top_hinges: Node3D = $TopHinges

var is_open: bool = false

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			Utils.create_collision_from_mesh(self, child)

func open():
	if is_open:
		return
	is_open = true
	var top = get_node("Top")
	if top:
		top.queue_free()
	var top_collision = get_node("Top_Collision")
	if top_collision:
		top_collision.queue_free()
	
	top_hinges.visible = true
	animation_player.play("crate_open")
	await animation_player.animation_finished
	top_hinges.queue_free()
	
