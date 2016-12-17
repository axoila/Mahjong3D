extends Object

var tile_amount = 1
var textures = []

func setup(tile_directory):
	pass
	#textures.append(load("res://Tiles/Tile0000.png"))
	
#	var dir = Directory.new()
#	if dir.open(tile_directory) == OK:
#		dir.list_dir_begin()
#		var file_name = dir.get_next()
#		var index = 0
#		while file_name != "" && index < tile_amount:
#			if dir.current_is_dir():
#				print("Directory " + file_name + " is not where it should be...");
#			else:
#				var tex = load(dir.get_current_dir()+"/"+file_name)
#				textures.append(tex)
#			file_name = dir.get_next()
#			index += 1
#		if index < tile_amount:
#			tile_amount = index-2
#		print(str(tile_amount, " kinds of tiles"))
	
func get(index):
	return null
#	return textures[index%tile_amount]