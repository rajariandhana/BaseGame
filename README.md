# BaseGame

## Player
Player has a RayCast in the middle of the camera / crosshair. When RayCast collided with Interactable it will act accordingly. `Interactable.interact(action, body)` can have different outcomes according to `action`.

## Use
on ground: pickup -> E
on hand: use -> MOUSE_LEFT
	pointing: use according to target
on hand: use -> MOUSE_RIGHT
	pointing: use according to target
on hand && pointing ground: drop -> Q

I should limit the amount of interaction keys


OOOO maybe just have Interactable which can be instantiated on ground, and Item extends Interactable which will be on equip
Item extends Interactable
Can exist on ground, at hand, would probably have different meshes. Think of possibility of separating ItemEquipped and ItemGround.
-> is_equipped
When item is equipped (on player's hand), turn off the collider, gravity, etc so it is static at hand. 
| RayCast Collide | True | False |
| MOUSE_LEFT |
| MOUSE_RIGHT |

item.gd
```gd
extends Interactable
class_name Item
@export var: String name
@export var: Node item_equip
interact():
	pickup / swap / equip
```
Will be used as a base class so for any custom item eg:
```gd
extends Item

```


ItemEquip
