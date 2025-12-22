extends Interactable
class_name Item

signal request_equip(item: Node3D)

var is_equipped: bool = false

func setup_init() -> void:
	interactions[Inputs.Keys.EQUIP] = "Equip"
	#interactions[Inputs.Keys.USE_PRIMARY] = "Use Primary"

func interact(action: Inputs.Keys, body: Node) -> void:
	match action:
		Inputs.Keys.EQUIP:
			print("Equip ", name)
			request_equip.emit(self)
		#Inputs.Keys.USE_PRIMARY:
			#print("Use Primary ", my_name)

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
	print(my_name, ": use_primary on ", target.my_name)

func use_primary():
	print(my_name, ": use_primary")

func use_secondary_on_object(target: Interactable):
	print(my_name, ": use_secondary on ", target.my_name)

func use_secondary():
	print(my_name, ": use_secondary")
