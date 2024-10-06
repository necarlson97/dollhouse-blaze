extends CellConnector

var is_broken = false

func _input(event: InputEvent) -> void:
	if is_broken:
		return
	if Input.is_action_just_pressed("use_door"):
		for body in $WindowArea.get_overlapping_bodies():
			if body.is_in_group("player"):
				break_open()
				
				# TODO hurt hand
				if body.held == null:
					body.hurt(0.1)
			
		
func break_open():
	if is_broken:
		return
	is_broken = true
	get_node("RigidBody2D/CollisionShape2D").disabled = true
	$WindowOpen.show()
	$WindowClosed.hide()
	propegation_rate = 0.9
	$GPUParticles2D.emitting = true
