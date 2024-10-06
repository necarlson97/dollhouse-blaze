extends Node2D
class_name SmokeCell

# Ammount of smoke in this room [0-1]
var ammount = 0.0
const SIZE = 400 # TODO get from smoke cell or w/e

var COLOR_LIGHT = Color(Color.html("#666666"), 0.8)
var COLOR_HEAVY = Color(Color.BLACK, 0.8)

# How much smoke from flames
const PER_FLAME = 0.001

var connectors = {}

var neighbor_vectors = {
	"left": Vector2(-1, 0),
	"right": Vector2(SIZE+1, 0),
	"up": Vector2(0, -1),
	"down": Vector2(0, SIZE+1),
}
# How much to nudge walls to be in the right place
var connector_vectors = {
	"left": Vector2(0, SIZE/2),
	"right": Vector2(SIZE, SIZE/2),
	"up": Vector2(SIZE/2, 0),
	"down": Vector2(SIZE/2, SIZE),
}

func _ready() -> void:
	set_smoke_visuals()

func set_connectors():
	# Called once, after all cells are initilized, to help create the
	# graph of smoke cells
	var empty_connection_prefab = preload("res://scenes/building/connection.tscn")
	
	for key in neighbor_vectors:
		var nv = neighbor_vectors[key]
		var cv = connector_vectors[key]
		var neighbor_cell = Utils.get_smoke_cell(global_position + nv)
		var connector = Utils.get_connector_at_pos(global_position + cv)
		
		# Create a new connector, if no door/wall/floor exists
		if connector == null:
			connector = empty_connection_prefab.instantiate()
			add_child(connector)
			connector.global_position = global_position + cv
			connector.name = "%s %s"%[key, connector.global_position / SIZE]
			if key == "up" or key == "down":
				connector.rotate(PI/2)
			
		connectors[key] = connector
		connector.cells.append(self)
		if connector.cells.size() > 2:
			print("TOO MANTY CELLS AT %s: %s"%[global_position + cv, connector])
		
		# TODO do I need to set opposite? Or just sanity check it maybe?

func _draw() -> void:
	# TODO gross, they need debug draw
	for key in neighbor_vectors:
		var nv = neighbor_vectors[key]
		var cv = connector_vectors[key]
		#draw_line(Vector2.ZERO, nv, Color.BLUE, 3)
		#draw_line(Vector2.ZERO, cv, Color.RED, 5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	propegate_smoke()

func set_smoke_visuals() -> void:
	$"Sprite2D".modulate = COLOR_LIGHT.lerp(COLOR_HEAVY, ammount)
	var height = SIZE * ammount
	$"Sprite2D".scale.y = height
	
func add_smoke(to_add=null) -> bool:
	if to_add == null:
		to_add = PER_FLAME
	ammount += to_add
	ammount = clamp(ammount, 0, 1)
	set_smoke_visuals()
	return ammount < 1.0
	
func propegate_smoke() -> void:
	# TODO DEBUG
	# TODO connectors empty from restart
	if ammount == 0 || connectors.size() == 0:
		return 

	# Smoke never propegates down
	var prop_keys = connectors.keys().filter(func(k): return k != "down" )
	# We choose a random one to propegate to to prevent call order defining prop order
	# TODO sloppy?
	var random_key = prop_keys[randi() % prop_keys.size()]
	var conn = connectors[random_key]
	
	conn.propegate(self)
	
func _to_string():
	return "SC %s %0.1f"%[global_position, ammount]
