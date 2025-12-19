extends Node
class_name Util

func input_map_value(key: Inputs.Keys):
	return Inputs.Mapping[key]

func input_map_key(value: String):
	for key in Inputs.Mapping:
		if Inputs.Mapping[key] == value:
			return key
