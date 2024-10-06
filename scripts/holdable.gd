extends Area2D

var item: Node2D
var holding_player = null
func _ready() -> void:
	item = get_parent()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pick_up"):
		if is_held():
			holding_player.drop_held()
		else:
			for body in get_overlapping_bodies():
				if body.is_in_group("player"):
					pick_up(body)

func pick_up(player):
	player.drop_held()
	print("picking up %s"%[self])
	item.position = Vector2.ZERO
	item.rotation = 0
	item.get_parent().remove_child(item)
	player.get_hold_spot().add_child(item)
	player.held = self
	holding_player = player
	var rbc = item.get_node_or_null("RigidBody2D/CollisionShape2D")
	if rbc == null:
		rbc = item.get_node("CollisionShape2D")
	rbc.disabled = true
	item.get_node("Area2D/CollisionShape2D").disabled = true

func drop():
	print("Dropping %s"%self)
	item.rotation = 0
	var gp = item.global_position
	holding_player.held = null
	holding_player = null
	var new_parent = get_tree().get_root()
	item.get_parent().remove_child(item)
	new_parent.add_child(item)
	item.global_position = gp
	
	var rbc = item.get_node_or_null("RigidBody2D/CollisionShape2D")
	if rbc == null:
		rbc = item.get_node("CollisionShape2D")
	rbc.disabled = false
	item.get_node("Area2D/CollisionShape2D").disabled = false

func is_held() -> bool:
	return holding_player != null

func _to_string() -> String:
	return "holdable %s"%item.name
