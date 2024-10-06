extends CellConnector

var is_broken = false

func _input(event: InputEvent) -> void:
	if is_broken:
		return
	if Input.is_action_just_pressed("use_door"):
		for body in $WindowArea.get_overlapping_bodies():
			if body.is_in_group("player"):
				break_open()
				# hurt hand
				if body.held == null:
					body.hurt(0.1)

func _on_body_entered(body):
	if is_broken:
		return
	var collision_velocity = 0
	if body is RigidBody2D:
		collision_velocity = body.linear_velocity.length()
	if body is CharacterBody2D:
		collision_velocity = body.velocity.length()
	if collision_velocity > 500:
		call_deferred("break_open")
		if body is Figure:
			body.hurt(0.2)

func break_open():
	if is_broken:
		return
	is_broken = true
	get_node("StaticBody2D/CollisionShape2D").disabled = true
	$WindowOpen.show()
	$WindowClosed.hide()
	propegation_rate = 0.9
	$GPUParticles2D.emitting = true
