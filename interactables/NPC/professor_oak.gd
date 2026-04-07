extends NPC

func respond(index: int, answer: String) -> int:
  print("index: ",index," answer: ",answer)
  match index:
    1:
      var new_line: String = "Oh so you are a "+answer+". "+get_line(index+1)
      set_line(index+1, new_line)
    2:
      var new_line: String = get_line(index+1)+answer+"!"
      set_line(index+1, new_line)
  return index + 1