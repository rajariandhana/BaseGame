extends RayCast3D

@export var player: Player

@export var moveable_state: State
@export var talking_state: State

var interacting: Interactable = null

func scan() -> State:
  # TODO: why are there repetitive setting of hover_message.text
  player.hover_message.text = ""

  if is_colliding():
    var res: State = handle_interaction()
    if res:
      return res
  else:
    clear_hover()
  if player.is_equipped():
    player.handle_equipped()
  
  return null

func handle_interaction() -> State:
  var collider: Object = get_collider()

  if collider is Interactable:
    var res: State = handle_interactable(collider)
    if res:
      return res
    return null
  #if Utils.action_pressed([Inputs.Keys.DROP]) and collider.is_in_group("ItemZone"):
    #drop(interact_ray.get_collision_point())
  return null

func handle_interactable(collider: Interactable) -> State:
  if interacting != collider:
    var res: State = switch_hover(collider)
    if res:
      return res

  player.hover_message.text = collider.get_prompt()
  for action: int in collider.interactions.keys():
    if Utils.action_pressed([action]):
      collider.interact(action, owner)
  return null

func clear_hover() -> void:
  if interacting:
    interacting.hover_exit(owner)
    interacting = null

func switch_hover(new_target: Interactable) -> State:
  if interacting:
    if interacting is Talkable:
      # player.begin_dialogue(interacting)
      interacting.dialogue_requested.disconnect(player.begin_dialogue)
      return talking_state
    interacting.hover_exit(owner)
  interacting = new_target
  interacting.hover_enter(owner)

  if interacting is Item:
    if not interacting.request_equip.is_connected(player.equip):
      interacting.request_equip.connect(player.equip)
    if not interacting.request_pickup.is_connected(player.pickup):
      interacting.request_pickup.connect(player.pickup)
  if interacting is Talkable:
    if not interacting.dialogue_requested.is_connected(player.begin_dialogue):
      interacting.dialogue_requested.connect(player.begin_dialogue)
  
  return null