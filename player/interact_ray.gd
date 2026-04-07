extends RayCast3D

@export var player: Player

@export var moveable_state: State
@export var talking_state: State

var interacting: Interactable = null

func scan() -> State:
  # TODO: why are there repetitive setting of hover_message.text

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
    return handle_interactable(collider)
  #if Utils.action_pressed([Inputs.Keys.DROP]) and collider.is_in_group("ItemZone"):
    #drop(interact_ray.get_collision_point())
  return null

func handle_interactable(collider: Interactable) -> State:
  if interacting != collider:
    switch_hover(collider)

  player.hover_message.text = collider.get_prompt()
  for action: int in collider.interactions.keys():
    if Utils.action_pressed([action]):
      collider.interact(action, owner)
      if collider is Talkable:
        return talking_state
  return null

func clear_hover() -> void:
  if interacting:
    interacting.hover_exit(owner)
    interacting = null
    player.hover_message.text = ""

func switch_hover(new_target: Interactable) -> void:
  if interacting:
    interacting.hover_exit(owner)
  interacting = new_target
  interacting.hover_enter(owner)

  if interacting is Item:
    if not interacting.request_equip.is_connected(player.equip):
      interacting.request_equip.connect(player.equip)
    if not interacting.request_pickup.is_connected(player.pickup):
      interacting.request_pickup.connect(player.pickup)