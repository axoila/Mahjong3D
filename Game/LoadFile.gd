extends FileDialog


func _ready():
	connect("file_selected", self, "load_file")
	pass

func load_file(path):
	var file = File.new()
	file.open(path, file.READ)
	var data = file.get_as_text()
	file.close()
	get_node("../../").layout = data
	get_node("../Panel/HBoxContainer").new_game()