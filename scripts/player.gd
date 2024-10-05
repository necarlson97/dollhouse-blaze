extends Figure
var skip_jump = false

# Held object
var held = null

func _input(event):
	handle_scroll(event)

func handle_scroll(event):
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

func get_moves():
	if !dead:
		if Input.is_action_pressed("ui_left"):
			velocity.x = -WALK_SPEED
		elif Input.is_action_pressed("ui_right"):
			velocity.x =  WALK_SPEED

		# Jumping (only if on the floor)
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			if skip_jump:
				skip_jump = false
			else:
				velocity.y = JUMP_FORCE

func handle_smoke():
	var cell = Utils.get_smoke_cell(global_position - Vector2(0, 150))
	if cell == null:
		lung_health += 0.001
	else:
		lung_health -= cell.ammount * 0.001
	lung_health = clamp(lung_health, 0, 1)
	
	$AnimatedSprite2D.modulate = Color.from_hsv(0, 1-blood_health, lung_health, 1)
	
	if blood_health <= 0 || lung_health <= 0:
		die()
	
func _process(delta: float) -> void:
	if dead:
		return
		
	var tip_text = ""
	for area in get_tree().get_nodes_in_group("interaction area"):
		if self in area.get_overlapping_bodies():
			if "Stair Down" in area.name:
				tip_text += "\nPress w to ascend"
			elif "Stair Up" in area.name:
				tip_text += "\nPress s to descend"
			elif "Door" in area.name:
				if area.get_parent().is_locked:
					tip_text += "\nPress e to punch with your %s"%held_str()
				else:
					tip_text += "\nPress e to open/close"
			elif "Window" in area.name:
				tip_text += "\nPress e to smash with your %s"%held_str()
			else:
				tip_text += "\nPress f to take %s"%area.get_parent().name
			
	$ToolTip.text = tip_text

func held_str() -> String:
	var held_name = "hand"
	if held:
		held_name = held.name
	return held_name
	
func drop_held():
	if held != null:
		held.drop()
