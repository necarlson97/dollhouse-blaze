extends Node2D

const SIZE = 400
var FLOORS = 2
var ROOMS = 4
var FRIENDS = 2
@export var skip_room_build = false

var wall = preload("res://scenes/building/wall wood.tscn")
var door = preload("res://scenes/building/door.tscn")
var stairs = preload("res://scenes/building/stairs.tscn")
var window = preload("res://scenes/building/window.tscn")
var rooms = [
	preload("res://scenes/rooms/bathroom large.tscn"),
	preload("res://scenes/rooms/bathroom small.tscn"),
	preload("res://scenes/rooms/bathroom segmented.tscn"),
	preload("res://scenes/rooms/kitchen.tscn"),
	preload("res://scenes/rooms/hall.tscn"),
	preload("res://scenes/rooms/hall med.tscn"),
	preload("res://scenes/rooms/hall long.tscn"),
	preload("res://scenes/rooms/den.tscn"),
]

func _ready() -> void:
	var diff = get_node_or_null("difficulty")
	if diff != null:
		FLOORS = diff.get_floors()
		ROOMS = diff.get_rooms()
		FRIENDS = diff.get_friend_count()
	build()
	
func build():
	create_smoke_cells()
	if !skip_room_build:
		build_rooms()
		build_stairs()
		place_friends()
		
	build_windows()
	build_roof()

	make_graph()
	sanity_check()

func build_rooms():
	for f in range(FLOORS):
		var remaining = ROOMS
		var available = rooms
		
		while remaining > 0:
			available = available.filter(func(r):
				return r.instantiate().cell_size <= remaining
			)
			var new_room = available[randi() % available.size()].instantiate()
			add_child(new_room)
			new_room.position.x = (ROOMS - remaining) * SIZE
			new_room.position.y = f * -SIZE
			remaining -= new_room.cell_size
		
			if remaining > 0 and "hall" not in new_room.name:
				var new_door = door.instantiate()
				new_door.name = "door %s %s"%[f, remaining]
				new_door.position.x = (ROOMS - remaining) * SIZE
				new_door.position.y = (f * -SIZE) - SIZE/2
				add_child(new_door)

func build_windows():
	# Build exterior doors/windows
	# Create windows / doors on first level
	for f in range(FLOORS):
		var barrier = window
		
		if f == 0:
			barrier = door
			
		var left = barrier.instantiate()
		left.name = "barreir left %s"%f
		var y = (f * -SIZE) - SIZE/2
		left.position.x = 0
		left.position.y = y
		add_child(left)
		var right = barrier.instantiate()
		right.name = "barreir right %s"%f
		right.position.x = ROOMS * SIZE
		right.position.y = y
		add_child(right)

func build_stairs():
	# Make sure we don't add stairs ontop of eachother
	var stair_locations = {0: -1}
	for f in range(FLOORS):
		# Create a random stair on every floor
		if f == 0:
			continue
		var stair_room = randi_range(0, ROOMS - 1)
		while stair_locations[f-1] == stair_room:
			stair_room = randi_range(0, ROOMS - 1)
		stair_locations[f] = stair_room
		var new_stairs = stairs.instantiate()
		new_stairs.name = "stairs %s to %s"%[f-1, f]
		new_stairs.position.x = stair_room * SIZE
		new_stairs.position.y = f * -SIZE
		add_child(new_stairs)

func build_roof():
	# Create roof
	for r in range(ROOMS):
		var roof =  wall.instantiate()
		roof.position.x = (r * SIZE) + SIZE/2
		roof.position.y = FLOORS * -SIZE
		roof.rotate(PI/2)
		roof.name = "roof %s"%r
		add_child(roof)
		# TODO I shouldn't have to do this
		roof.propegation_rate = 0.01
	
	# The visual-only roof facade
	var rl = preload("res://scenes/building/roof_left.tscn")
	var rm = preload("res://scenes/building/roof_middle.tscn")
	var rr = preload("res://scenes/building/roof_right.tscn")
	
	for r in range(ROOMS):
		var facade_prefab = rm
		if r == 0:
			facade_prefab = rl
		if r == ROOMS-1:
			facade_prefab = rr
		var rf =  facade_prefab.instantiate()
		rf.position.x = r * SIZE
		rf.position.y = FLOORS * -SIZE
		rf.name = "roof facade %s"%r
		add_child(rf)

func create_smoke_cells():
	var smoke_cell = preload("res://scenes/smoke_cell.tscn")
	for f in range(FLOORS):
		for r in range(ROOMS):
			var new_smoke_cell =  smoke_cell.instantiate()
			new_smoke_cell.position.x = r * SIZE
			new_smoke_cell.position.y = (1 + f) * -SIZE
			add_child(new_smoke_cell)

func place_friends():
	var previous_placements = ["0 0"]
	
	for i in range(FRIENDS):
		var r = 0
		var f = 0
		var placed = previous_placements[0]
		
		while placed in previous_placements:
			r = randi_range(0, ROOMS-1)
			f = randi_range(0, FLOORS-1)	
			placed = "%s %s"%[r, f]
			
		var friend = preload("res://scenes/friend.tscn").instantiate()
		friend.position = Vector2((r + 0.5) * SIZE, f * -SIZE)
		add_child(friend)

func make_graph():
	# Now that all cells, walls, doors, etc are laid out - populate the
	# smoke cell 'connectors' so that the smoke propegation is handled
	# graph-wise (see SmokeCell propegate for details)
	var all_cells = get_tree().get_nodes_in_group("smoke cell");
	for cell in all_cells:
		await get_tree().physics_frame
		cell.set_connectors()
		
	for s in get_tree().get_nodes_in_group("stairs"):
		s.open_connector()
		
func sanity_check():
	var expected = (FLOORS * ROOMS * 2) + FLOORS + ROOMS
	for i in range(expected):
		await get_tree().physics_frame
	var all_connectors = get_tree().get_nodes_in_group("connector");
	if all_connectors.size() != expected:
		print("%s != %s"%[all_connectors.size(), expected])
		for i in range(all_connectors.size()):
			print("  %s: %s"%[i, all_connectors[i].name])
	assert(all_connectors.size() == expected, "%s != %s"%[all_connectors.size(), expected])
	
