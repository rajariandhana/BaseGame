extends Talkable
class_name NPC

func _ready() -> void:
  super()
  var mesh_instance_3d: MeshInstance3D = $"./MeshInstance3D"
  if mesh_instance_3d:
    Utils.set_overlay_color(Utils.get_random_color(), mesh_instance_3d)

func respond(index: int, answer: String) -> int:
  print("index: ",index," answer: ",answer)
  if index == 1:
    if answer == "Yes":
      return 5
  return index + 1