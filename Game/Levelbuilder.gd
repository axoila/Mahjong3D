extends Object

var parent #the node to parent objects to - set before generating!
var row_size = 1
var col_size = 1
var level_height = 1

var __level_amount
var __row_amount
var __column_amount

var brick_amount
var __brick_types = []

var __block_dict = {}
var __tile_mngr

func make_map(packed_object, layout):
	__tile_mngr = load("res://TileManager.gd").new()
	__tile_mngr.tile_amount = 100;
	__tile_mngr.setup("res://Tiles")
	
	var levels = layout.split("\n-\n")
	__level_amount = levels.size()
	__row_amount = -1
	__column_amount = -1
	brick_amount = 0
	for l in levels:
		var rows = l.split("\n")
		if rows.size() > __row_amount:
			__row_amount = rows.size()
		for r in rows:
			if r.length() > __column_amount:
				__column_amount = r.length()
			var columns = r.to_ascii()
			for c in columns:
				if c != 32:
					brick_amount += 1
	print(brick_amount)
	__brick_types = []
	for i in range(brick_amount/2):
		__brick_types.append(0)
	
	if brick_amount % 2 != 0:
		print("UNEVEN AMOUNT OF BRICKS")
		return
	
	print("making map:\n", __level_amount, " levels\n", __row_amount, " rows\n", __column_amount, " columns")
	__block_dict.clear()
	
	var level_number = 0
	for l in levels:
		make_level(packed_object, l, level_number)
		level_number += 1
	return __block_dict
	

func make_level(packed_object, layout, level_number = 0): #instances a packedobject on a layout 
	var rows = layout.split("\n")
	
	var row_number = 0
	for r in rows:
		make_col(packed_object, r, row_number, level_number)
		row_number += 1

func make_col(packed_object, layout, row_number = 0, level_number = 0):
	var col_number = 0
	for c in range(layout.length()):
		if layout.ord_at(c) != 32: #32 is space
			var new = packed_object.instance()
			parent.add_child(new)
			new.set_translation(Vector3((col_number - __column_amount/2)*col_size, -(level_number - __level_amount/2) * level_height, (row_number - __row_amount/2)*row_size))
			__block_dict[Vector3(col_number, level_number, row_number)] = new
			new.pos = Vector3(col_number, level_number, row_number)
			var type = randi() % (brick_amount/2)
			while __brick_types[type] >= 2:
				type = randi() % (brick_amount/2)
			__brick_types[type] += 1
			new.tile = type
			
			new.initialize(__tile_mngr)
		col_number += 1



