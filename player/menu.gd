extends CanvasLayer

func _ready() -> void:
  close()

func open() -> void:
  visible = true

func close() -> void:
  visible = false

func _on_button_pressed() -> void:
  print("button on menu clicked")
