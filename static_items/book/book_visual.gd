extends Interactable

const MIN_HEIGHT: float = 0.4
const MAX_HEIGHT: float = 0.6

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
var animation_player: AnimationPlayer

var is_pulled: bool = false
var is_moving: bool = false

var pullable: bool
var pull_effect: Node

func _ready() -> void:
	super()

func setup(book_display_name: String, book_pullable: bool, custom_height: float, custom_color: String, book_animation_player: AnimationPlayer, book_interactions: Dictionary[Inputs.Keys, String], book_pull_effect: Node) -> void:
	display_name = book_display_name
	pullable = book_pullable
	animation_player = book_animation_player
	interactions = book_interactions
	pull_effect = book_pull_effect

	if pullable:
		interactions[Inputs.Keys.E] = "Pull"
	if custom_height == 0.0:
		custom_height = randf_range(MIN_HEIGHT, MAX_HEIGHT)

	mesh_instance_3d.scale.y = custom_height
	mesh_instance_3d.position.y = custom_height * 0.5

	if custom_color.is_empty():
		custom_color = Utils.get_random_color()

	Utils.set_overlay_color(custom_color, mesh_instance_3d)
	Utils.create_collision_from_mesh(self, mesh_instance_3d)

func toggle_pull() -> void:
	if !pullable or is_moving:
		return

	is_moving = true
	if !is_pulled:
		animation_player.play("pull")
		await animation_player.animation_finished
		interactions[Inputs.Keys.E] = "Push"
	else:
		animation_player.play_backwards("pull")
		await animation_player.animation_finished
		interactions[Inputs.Keys.E] = "Pull"
	is_moving = false
	is_pulled = !is_pulled
	get_parent().is_pulled = is_pulled
	if pull_effect.has_method("pull"):
		pull_effect.pull(get_parent(), is_pulled)

func interact(action: Inputs.Keys, body):
	if action == Inputs.Keys.E:
		toggle_pull()
