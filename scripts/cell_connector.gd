extends Node2D
class_name CellConnector
# Includes the walls, doors, and, notably, empty spaces
# that connect cells

# How much smoke propegation is inhibited
@export var propegation_rate: float

# tuple of the connected cells
var cells = []

func other_cell(my_cell: SmokeCell) -> SmokeCell:
	# return the cell that isn't sc
	for sc in cells:
		if sc != my_cell:
			return sc
	return null

func _process(delta: float) -> void:
	debug_label()
	queue_redraw()
	
func debug_label():
	return
	# TODO just a quick debug label
	var debug_node = get_node_or_null("Debug")
	if debug_node == null:
		debug_node = Node2D.new()
		add_child(debug_node)
		debug_node.name = "Debug"
		debug_node.rotate(-PI/2)
		debug_node.position = Vector2(0, 200)
		debug_node.z_index = 2
		
	var debug_label: Label = get_node_or_null("Debug/Label")
	if debug_label == null:
		debug_label = Label.new()
		debug_label.name = "Label"
		debug_node.add_child(debug_label)
		debug_label.modulate = Color.RED
		
	debug_label.text = str(self)
	debug_label.position = Vector2.ZERO
	
var _origin_draw = null
var _other_draw = null
func propegate(origin_cell):
	# Push smoke from once cell to another
	var other_cell = other_cell(origin_cell)
	# Lower prop rate if there is an obstruction:
	var smoke_ammount = origin_cell.ammount * 0.01 * propegation_rate
	
	if smoke_ammount == 0:
		return
	
	# TODO DEBUG REMOVE
	_origin_draw = origin_cell
	
	# If on edge, cell should dump smoke out to world
	if other_cell == null:
		origin_cell.ammount -= smoke_ammount
	elif other_cell.ammount < origin_cell.ammount:	
		# Otherwise, it should only loose smoke of the other
		# 'has room', i.e., some of our smoke moves to it
		var had_room = other_cell.add_smoke(smoke_ammount)
		if had_room:
			origin_cell.ammount -= smoke_ammount
			
		_other_draw = other_cell
	
	origin_cell.ammount = clamp(origin_cell.ammount, 0, 1)

func _draw():
	return
	
	var radius = 50 * propegation_rate
	if _origin_draw != null:
		var ori = _origin_draw.global_position - global_position
		draw_circle(ori, 3, Color.RED)
		
		if _other_draw != null:
			var oth = _other_draw.global_position - global_position
			var offset = Vector2(200, 200)
			draw_line(ori+offset, oth+offset, Color.GREEN, radius)
		else:
			draw_line(Vector2.ZERO, Vector2(-100, 0), Color.RED, radius)
	
	_other_draw = null
	_origin_draw = null

func _to_string():
	return "%s: %s"%[name, cells]
