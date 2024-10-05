extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# TODO DEBUG
func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_one"):
		print(get_at_pos(get_global_mouse_position()))
	if event.is_action_released("mouse_two"):
		var fire = preload("res://scenes/flame.tscn").instantiate()
		fire.global_position = get_global_mouse_position()
		add_child(fire)
	
func get_smoke_cell(pos: Vector2):
	# Get the smoke cell that contains the given position
	var all_cells = get_tree().get_nodes_in_group("smoke cell");
	for c in all_cells:
		var rect = Rect2(c.global_position, Vector2(c.SIZE, c.SIZE))
		if rect.has_point(pos):
			return c
	return null

func get_connector_at_pos(pos: Vector2):
	var all = get_all_at_pos(pos)
	all = all.filter(func(c): return c.is_in_group("connector"))
	if all.size() > 1:
		print("Multiple at %s: %s"%[pos, all])
		return all[0]
	if all.size() > 0:
		return all[0]
	return null
	
	
func get_at_pos(pos: Vector2):
	var all = get_all_at_pos(pos)
	if all.size() > 1:
		print("Multiple at %s: %s"%[pos, all])
		return all[0]
	if all.size() > 0:
		return all[0]
	return null
	
func get_all_at_pos(pos: Vector2) -> Array:
	# Get the object(s) with a collision shape at the given pos
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var results = space_state.intersect_point(query)

	var hit_nodes = []
	for result in results:
		var collider = result.collider
		if collider.get_parent().is_in_group("player"):
			continue  # Skip this collider if it's part of the player
		if collider.is_in_group("interaction area"):
			continue
		hit_nodes.append(collider.get_parent())

	return hit_nodes
