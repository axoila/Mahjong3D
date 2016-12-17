extends Spatial

export(Material) var unselected_mat
export(Material) var selected_mat

var unique_index = -1;
var pos = Vector3()

var tile = -1
var tile_mngr

func _ready():
	deselect()

func is_selectable(brick_dict):
	if !brick_dict.has(pos + Vector3(0, 1, 0)) || !brick_dict.has(pos + Vector3(0, -1, 0)):
		if !brick_dict.has(pos + Vector3(1, 0, 0)) || !brick_dict.has(pos + Vector3(-1, 0, 0)):
			return true
	return false

func is_same(other):
	return tile % tile_mngr.tile_amount == other.tile % tile_mngr.tile_amount

func select():
	get_node("outline").show()
	get_node("brick_mesh").set_material_override(selected_mat)

func deselect():
	get_node("outline").hide()
	get_node("brick_mesh").set_material_override(unselected_mat)

func initialize(tile_mngr):
	unique_index = randf()
	self.tile_mngr = tile_mngr
	var col = Color(1, 1, 1)
	#col.h = tile / 20.0
	unselected_mat = unselected_mat.duplicate(true)
	unselected_mat.set_shader_param("DiffuseColor", col)
	unselected_mat.set_shader_param("Tile", tile_mngr.get(tile))
	selected_mat = selected_mat.duplicate(true)
	selected_mat.set_shader_param("DiffuseColor", col)
	selected_mat.set_shader_param("Tile", tile_mngr.get(tile))
	deselect()


