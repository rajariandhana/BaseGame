extends Talkable
var line_3: String

func _ready() -> void:
	super()
	line_3 = get_line(3)
	# interactions[Inputs.Keys.E] = "Turn On"

func respond(index: int, answer: String) -> int:
	print("index: ",index," answer: ",answer)
	match index:
			2:
				var new_line: String = get_line(index+1) + answer+"?"
				set_line(index+1, new_line)
			3:
				if answer == "No":
					set_line(3, line_3)
					return 2
	return index + 1