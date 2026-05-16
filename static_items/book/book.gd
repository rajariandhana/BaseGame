extends Interactable
class_name Book

const MIN_HEIGHT: float = 0.4
const MAX_HEIGHT: float = 0.6

@export var custom_height: float
@export var custom_color: String

@export var pullable: bool = false
var is_pulled: bool = false
var is_moving: bool = false

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()

	# var old_pos = position
	if pullable:
		interactions[Inputs.Keys.E] = "Pull"
	else:
		interactions[Inputs.Keys.E] = ""
	
	if custom_height == 0.0:
		custom_height = randf_range(MIN_HEIGHT, MAX_HEIGHT)
	
	mesh_instance_3d.scale.y = custom_height
	mesh_instance_3d.position.y = custom_height / 2
	Utils.create_collision_from_mesh(self, mesh_instance_3d)
	# position = Vector3(old_pos.x, position.y, old_pos.z)

	if custom_color.is_empty():
		custom_color = Utils.get_random_color()
	Utils.set_overlay_color(custom_color, mesh_instance_3d)

func interact(action: Inputs.Keys, body):
	match action:
		Inputs.Keys.E:
			toggle_pull()

func toggle_pull() -> void:
	if !pullable || is_moving:
		return
	
	is_moving = true
	if !is_pulled:
		animation_player.play("pull")
		await animation_player.animation_finished
		interactions[Inputs.Keys.E] = "Push"
		is_pulled = true
	else:
		animation_player.play_backwards("pull")
		await animation_player.animation_finished
		interactions[Inputs.Keys.E] = "Pull"
		is_pulled = false
	is_moving = false
