extends Node2D

func _input(event: InputEvent) -> void:
		
	if Input.is_action_just_pressed("pick_up"):
		if get_parent().is_in_group("player"):
			get_parent().drop_held()
		else:
			for body in $Area2D.get_overlapping_bodies():
				if body.is_in_group("player"):
					pick_up(body)

func pick_up(player):
	player.drop_held()
	print("picking up %s"%[self.name])
	rotation = 0
	get_parent().remove_child(self)
	player.add_child(self)
	player.held = self
	get_node("RigidBody2D/CollisionShape2D").disabled = true
	get_node("Area2D/CollisionShape2D").disabled = true
	# TODO would be different - also, skeleton?
	position = Vector2(0, -200)
	print("parent: %s"%get_parent())

func drop():
	print("Dropping %s"%self.name)
	rotation = PI/2
	var gp = global_position
	get_parent().held = null
	var new_parent = get_tree().get_root().get_node("main")
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = gp + Vector2(0, 150) # TODO sloppy
	
	get_node("RigidBody2D/CollisionShape2D").disabled = false
	get_node("Area2D/CollisionShape2D").disabled = false
	
