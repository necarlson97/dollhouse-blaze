extends StaticBody2D

const BREAK_THRESHOLD = 500.0

func _on_body_entered(body):
	print("Window pane: %s"%body)
	# Check if the body has sufficient velocity to break the window
	var collision_velocity = body.linear_velocity.length()
	if collision_velocity > BREAK_THRESHOLD:
		get_parent().break_open()
		if body is Figure:
			body.hurt(0.2)
