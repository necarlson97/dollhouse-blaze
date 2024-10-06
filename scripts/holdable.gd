extends Area2D

var item: Node2D
func _ready() -> void:
	item = get_parent()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pick_up"):
		if is_held():
			get_holding_player().drop_held()
		else:
			for body in get_overlapping_bodies():
				if body.is_in_group("player"):
					pick_up(body)

func pick_up(player):
	player.drop_held()
	item.position = Vector2.ZERO
	item.rotation = 0
	item.get_parent().remove_child(item)
	player.get_hold_spot().add_child(item)
	player.held = self
	var rbc = get_rigidbody().get_node("CollisionShape2D")
	rbc.disabled = true
	if item is RigidBody2D:
		item.freeze = true
	item.get_node("Area2D/CollisionShape2D").disabled = true
	
	print("picking up %s (%s)"%[self, get_holding_player()])

func drop():
	print("Dropping %s"%self)
	item.rotation = 0
	var gp = item.global_position
	get_holding_player().held = null
	var new_parent = get_tree().get_first_node_in_group("dollhouse")
	item.get_parent().remove_child(item)
	new_parent.add_child(item)
	item.global_position = gp
	
	var rbc = get_rigidbody().get_node("CollisionShape2D")
	rbc.disabled = false
	if item is RigidBody2D:
		item.freeze = false
	item.get_node("Area2D/CollisionShape2D").disabled = false

func get_rigidbody():
	if item is RigidBody2D or item is CharacterBody2D:
		return item
	var rb = item.get_node_or_null("RigidBody2D")
	if rb != null:
		return rb
	return null
	
func add_velocity(x):
	if item is RigidBody2D:
		item.linear_velocity.x += x
	if item is CharacterBody2D:
		item.velocity.x += x * 5
		print("Throw chracter: %s"%item.velocity)

func is_held() -> bool:
	return get_holding_player() != null

func get_holding_player():
	# TODO sloppy?
	var p = get_tree().get_first_node_in_group("player")
	if p.held == self:
		return p
	return null

func _to_string() -> String:
	return "holdable %s"%item.name
