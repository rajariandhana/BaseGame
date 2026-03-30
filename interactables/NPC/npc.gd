extends Talkable

func _ready() -> void:
  reset()
  var mesh_instance_3d: MeshInstance3D = $"./MeshInstance3D"
  if mesh_instance_3d:
    Utils.set_overlay_color(Utils.get_random_color(), mesh_instance_3d)