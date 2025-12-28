extends Interactable
class_name Item

@export var item_ID: String

signal request_equip(item: Node3D)

# Makes it only set on layer 3
const ITEM_DEFAULT_COLLISION_LAYER := 1 << (3 - 1)

# Will be filled with whatever rotation has been set
#var reset_rotation: Vector3
#@export var equip_rotation: Vector3

var is_equipped: bool = false

# child must not use built in _init() and or _ready()
# use _init_item() _ready_item() instead
func _init_interactable() -> void:
	interactions[Inputs.Keys.EQUIP] = "Equip"
	#interactions[Inputs.Keys.USE_PRIMARY] = "Use Primary"
	collision_layer = ITEM_DEFAULT_COLLISION_LAYER
	_init_item()
func _ready_interactable() -> void:
	var data: ItemData = ItemDB.get_item(item_ID)
	if display_name == null or display_name.is_empty():
		display_name = data.display_name
	_ready_item()
func _init_item() -> void:
	pass
func _ready_item() -> void:
	pass

func interact(action: Inputs.Keys, body: Node) -> void:
	match action:
		Inputs.Keys.EQUIP:
			print("Equip ", display_name)
			request_equip.emit(self)
		#Inputs.Keys.USE_PRIMARY:
			#print("Use Primary ", display_name)

func use(key: Inputs.Keys, target: Node):
	match key:
		Inputs.Keys.USE_PRIMARY:
			if target is Interactable:
				use_primary_on_object(target)
			else:
				use_primary()
		Inputs.Keys.USE_SECONDARY:
			if target is Interactable:
				use_secondary_on_object(target)
			else:
				use_secondary()

func equip():
	is_equipped = true

# filled with pass so child can override
func use_primary_on_object(target: Interactable):
	print(display_name, ": use_primary on ", target.display_name)

func use_primary():
	print(display_name, ": use_primary")

func use_secondary_on_object(target: Interactable):
	print(display_name, ": use_secondary on ", target.display_name)

func use_secondary():
	print(display_name, ": use_secondary")
