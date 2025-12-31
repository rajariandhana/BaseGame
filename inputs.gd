extends Node
class_name Inputs

enum Keys {
	E,
	F,
	Q,
	EQUIP,
	PICKUP,
	DROP,
	USE_PRIMARY,
	USE_SECONDARY,
	OPEN_INVENTORY,
}

const Mapping := {
	Keys.E: "interact_e",
	Keys.F: "interact_f",
	Keys.Q: "interact_q",
	Keys.EQUIP: "interact_e",
	Keys.PICKUP: "interact_f",
	Keys.DROP: "interact_q",
	Keys.USE_PRIMARY: "mouse_left_click",
	Keys.USE_SECONDARY: "mouse_right_click",
	Keys.OPEN_INVENTORY: "tab"
}
