extends Item

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func use_primary_on_object(target: Interactable):
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("use")
	target.queue_free()
