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
	var collision_velocity = body.linear_velocity.length()
	if collision_velocity > 500:
		get_parent().break_open()
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
