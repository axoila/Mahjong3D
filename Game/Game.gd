extends Spatial

export(PackedScene) var brick
export(String, MULTILINE) var layout

var camera
export(float) var pick_length
var from = Vector3()
var to = Vector3()
var queue_pick = false

var builder
var brick_dict = {}
var pairs = []

var selected = null

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
	camera = get_node("Y_rot/X_rot/Camera")
	
	#configure and make level
	randomize()
	builder = load("res://Levelbuilder.gd").new()
	builder.parent = get_node("Bricks")
	builder.row_size = 1.618
	builder.level_height = .3
	brick_dict = builder.make_map(brick, layout)
	update_display()
	
func _fixed_process(delta):
	if queue_pick:
		var space_state = get_world().get_direct_space_state()
		var result = space_state.intersect_ray(from, to)
		if !result.empty() && result.collider.is_selectable(brick_dict):
			if selected != null:
				selected.deselect()
				if selected == result.collider:
					selected.deselect()
					selected = null
					queue_pick = false
					return
				if selected.is_same(result.collider):
					brick_dict.erase(selected.pos)
					brick_dict.erase(result.collider.pos)
					selected.queue_free()
					result.collider.queue_free()
					update_display()
					selected = null
					queue_pick = false
					return
			result.collider.select()
			selected = result.collider
		queue_pick = false

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_LEFT && event.pressed:
		from = camera.project_ray_origin(event.pos)
		to = from + camera.project_ray_normal(event.pos) * pick_length
		queue_pick = true

func update_display():
	# update pairs
	pairs = []
	for brick in brick_dict.values():
		for other_brick in brick_dict.values():
			#if brick.tile % builder.brick_amount == other_brick.tile % builder.brick_amount:
				#print("PAIR OR SAME")
			if brick.unique_index != other_brick.unique_index && brick.is_selectable(brick_dict) && other_brick.is_selectable(brick_dict) && \
					brick.tile % builder.__tile_mngr.tile_amount == other_brick.tile % builder.__tile_mngr.tile_amount && \
					!pairs.has(brick) && !pairs.has(other_brick):
				pairs.append(brick);
				pairs.append(other_brick);
	get_node("Control/Panel/HBoxContainer/CurrentPossibilities").set_text(str("| ",pairs.size()/2," possible pairs"))
	
	get_node("Control/Panel/HBoxContainer/TilesLeft").set_text(str(brick_dict.size()," bricks left"))

