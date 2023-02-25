extends Node

var item_data: Dictionary

func save_data(file_path):
	var file = FileAccess.open("res://GameData/ItemData.json", FileAccess.WRITE)
	file.store_string(file_path)

func load_data():
	var file = FileAccess.open("res://GameData/ItemData.json", FileAccess.READ)
	var file_path = file.get_as_text()
	return file_path
