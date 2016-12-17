extends HBoxContainer



func _ready():
	get_node("New Game").connect("button_down", self, "new_game")
	get_node("Load File").connect("button_down", self, "load_file")
	get_node("Shuffle").connect("button_down", self, "shuffle")
	

func new_game():
	var game = get_node("/root/Mahjong")
	for b in game.get_node("Bricks").get_children():
		b.queue_free()
	game.builder.make_map(game.brick, game.layout)
	game.selected = null

func load_file():
	get_node("../../FileDialog").popup()

func shuffle():
	var game = get_node("/root/Mahjong")
	var __brick_types = []
	for i in range(game.builder.brick_amount/2):
		__brick_types.append(0)
	for brick in game.brick_dict.values():
		__brick_types[brick.tile] += 1
	
	for brick in game.brick_dict.values():
		brick.tile = randi() % game.builder.brick_amount/2
		while __brick_types[brick.tile] <= 0 : 
			brick.tile = randi() % game.builder.brick_amount/2
		__brick_types[brick.tile] -= 1
		brick.initialize(game.builder.__tile_mngr)