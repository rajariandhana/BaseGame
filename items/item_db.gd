extends Node

var items: Dictionary[String, ItemData] = {}

const ITEM_PATH = "res://items"

func _ready():
	load_items(ITEM_PATH)
	print_items()

func load_items(path: String) -> void:
	var dir := DirAccess.open(path)
	if not dir:
		return
	for file_name in dir.get_files():
		if file_name.ends_with(".tres"):
			var full_path: String = path.path_join(file_name)
			var data: ItemData = load(full_path)
			items[data.id] = data
	for subdir in dir.get_directories():
		load_items(path.path_join(subdir))

func print_items():
	for item: ItemData in items.values():
		print(str(item.id))

func get_item(id: String) -> ItemData:
	return items.get(id)
