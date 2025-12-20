extends Node
class_name Inputs

enum Keys {
	E,
	F,
	Q,
	PICKUP,
	DROP,
}

const Mapping := {
	Keys.E: "interact_e",
	Keys.F: "interact_f",
	Keys.Q: "interact_q",
	Keys.PICKUP: "interact_e",
	Keys.DROP: "interact_q",
}
