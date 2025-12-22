extends Node
class_name Inputs

enum Keys {
	E,
	F,
	Q,
	EQUIP,
	DROP,
}

const Mapping := {
	Keys.E: "interact_e",
	Keys.F: "interact_f",
	Keys.Q: "interact_q",
	Keys.EQUIP: "interact_e",
	Keys.DROP: "interact_q",
}
