extends CharacterBody2D

const GRAVITY = 1200.0
const WALK_SPEED = 400
const DAMPENING = 0.8

const JUMP_FORCE = -800.0
const MAX_FALL_SPEED = 1200.0

func _input(event):
	var scroll_value = 0
	
	if event.is_action_pressed("scroll_up"):
		scroll_value = 1
	if event.is_action_pressed("scroll_down"):
		scroll_value = -1
		
	if scroll_value == 0:
		return
	
	var camera = $Camera2D
	# Adjust the zoom by the scroll value
	var zoom_increment = 0.05 * scroll_value
	camera.zoom += Vector2(zoom_increment, zoom_increment)
	
	# Clamp the zoom to the desired limits
	camera.zoom.x = clamp(camera.zoom.x, 0.2, 1)
	camera.zoom.y = clamp(camera.zoom.y, 0.2, 1)

func _physics_process(delta):
	# Apply gravity and cap the fall speed
	if velocity.y < MAX_FALL_SPEED:
		velocity.y += delta * GRAVITY

	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x *= DAMPENING
		
	# Jumping (only if on the floor)
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_FORCE
		
	move_and_slide()
