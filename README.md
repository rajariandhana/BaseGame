# BaseGame - The game where art, story, music, does not matter
Many game developers (including me) produces an unfinished game. I'm a programmer so I'll try to ignore aestethicsm, gameplay, story, audio, and instead focus on the mechanics.

## Player
Player has a RayCast in the middle of the camera / crosshair. When RayCast collided with Interactable it will act accordingly. `Interactable.interact(action, body)` can have different outcomes according to `action`.

## Interactable
The base class for anything that the Player's raycast can interact with. `Interactable` extends `CollisionObject3D`. For each instance of Interactable modify the `interactions` dictionary to determine the input keys used to interact with the object and `interact()` to determine the action for each input.

## Item
The base class for `Item` extends `Interactable` and has a default interaction of picking up objects. `Item` are for objects that can be picked by the player. By default (through `_init_interactable()`), the collision layer of the Item will be overrided. Use `RigidBody3D` as the root scene so it can simulate physics (being dropped following gravity). It won't collide physically with other Items and Player.
To create an object create a new scene with `RigidBody3D` or `StaticBody3D` as root, create `MeshInstance3D` for visual and `CollisionShape3D` to determine the collision shape (how it will collide with the world and the size of it being detectable by Player). Create a new script that extends `Item` and attach it to the root, this will be the script where you can write custom behaviour for the object.

### Using Item
When an Item is equipped (currently at Player's hand) it can be used with different behaviour according to the input being used and to what object the Player is currently looking at. By default there are 4 types of use available.
| Inputs.Keys | Player raycast | Handler function | Description |
| - | - | - | - |
| `USE_PRIMARY` | `Interactable` | `use_primary_on_object(target: Interactable)` | Item is equipped and left click on Interactable |
| `USE_PRIMARY` | not `Interactable` | `use_primary()` | Item is equipped and left click on anything |
| `USE_SECONDARY` | `Interactable` | `use_secondary_on_object(target: Interactable)` | Item is equipped and right click on Interactable |
| `USE_SECONDARY` | not `Interactable` | `use_secondary()` | Item is equipped and right click on anything |

Since `target` is also passed to handler we can affect the target as well.

## Inventory
Maybe create another base scene like storage so have multiple places to store items. For example like in Minecraft there is player's inventory, chest, barrel which all of them can be used to store items.
ItemSlot is just a control node while Storage is an Interactable that has both collision, mesh for Player to interact and will open the UI.
Maybe have an ItemData so instead of storing a whole scene just store some data.
ItemSlot -> stores 1 item
	- on hover:
		- equip: if hand not empty swap
		- drop
Storage -> has N ItemSlot or dynamically resize, has UI
Inventory -> explicitly for Player,

## TODO:
- equip will unequip currently equipped into inventory (less inputs to press instead of equip + swap + put in inventory inputs), so inputs will just be equip + put in inventory
- create chests
- make a house, spawn inside, have to find a key to open the door outside, use axe to destroy stuffs.
- must move interactable into root Door node but detect from childs,
- different message prompt according Item hover on different Interactable
- mouse usage guide of item on hover
- crate open animation
- [ESC] -> show controls: [TAB] Inventory, etc?
- [E] Talk / continue / next, yes/no question
- replica of my apartment
- door can reverse open direction
- Talk -> Inputs.Keys.TALK
- IMPORTANT: separate mouse enable disable functionality
- button style theme learn it
- Temporary main menu so can play level 0
- NPC floating, idle, hands, hover above ground, refactor code
- Understand the F out of FSM
- there is a super() function in Godot
- introduce Economy
- create auto template for scripts, reusable
- dialogue state -> UI theme -> upload to itch.io

## Dialogue System - DialoguePanel, Talkable, DialogueLine
A "person" to talk to inherits `Talkable`. `Talkable` stores the dialogue lines as array of `DialogueLine` in `DialogueLines`. A `DialogueLine` have a type (`DialogueType`) to distinguish if it is a normal text or a question. An option of answer can also be declared.

`DialogueLines` is a one dimensional array. `Talkable.respond()` can be overriden to handle an answer given and return the index of the next dialogue line it should go to.

- TODO: consider changing linear dialogue to tree based dialogue

## Game Feel
- shake, recoil
- background loading
- smooth animation
- lighting

## References:
- https://www.youtube.com/watch?v=QKdyUBjzPmk
- https://www.youtube.com/watch?v=NJJNWGD25rg
- https://shaggydev.com/2023/10/08/godot-4-state-machines/

## Riot Essay

### In your own words, why are you interested in working at Riot Games?*
From my experience when creating games, I realize that I cannot do it alone. There are so many aspects in a game other than the code like the graphics, story, music, physics simulation. As someone with programming background it is just impossible to master everything. I'm interested in working at Riot Games because it offers me a chance to meet and collaborate with other talented people who shares the same passion for creating games.

According to past Riot employees testimony, Riot Games has created a work culture that allows their developers to output their potentials by giving trust, support, and top tier resources. By trusting their developers, Riot had created high quality games that can keep players engaged and having the best time. I am excited to work in an environtment like this, where I can fully contribute and keep growing as a developer.

### In your own words, why do you want to pursue this role professionally?*
I started by creating small games only for me and my friends to play, then I got the chance to work voluntarily in an organization. The games we made eventually reached over 1000 players, which raises problem in optimizing certain aspects of the game. We were afraid that some players would left because it was too uncomfortable for them to play. This experience made me interested to learn more about how to design and maintain games that scales for millions of players worldwide in order to keep players feeling joy and having fun.

The career path of a game developer has a wide variety of roles, game designer, level designer, systems designer, and such. I like to see the roles as different "levels" in a game with their own set of challanges that require different skills. Being a game developer gives me flexibility of trying different things, find what I like and dislike, what I'm best at, while still in an environnment that excites me.

Last year I participated in my first game jam organized by a YouTuber. At the event I teamed up with someone new that I've never met in real life. As an introvert I never thought could happen. We managed to finish a game that we like. Although our game were nowhere close to join the top games, it made me get out of my comfort zone and thrive.

Ultimately, I want to pursue this career profesionally because I enjoy both the creative and technical challange it has, it pushes me beyond my comfort zone, and gives joy to other people.

should I add game jam to resume projects?

## Player States
ray should be independent
