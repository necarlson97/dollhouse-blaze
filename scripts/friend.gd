extends Figure


var move_desire = 0
var saved = false

func _process(delta: float) -> void:
	if dead || is_held():
		move_desire = 0
		return
	if saved:
		move_desire = -1
		if global_position.x > 400:
			move_desire = 1
	elif randf() < 0.001:
		move_desire = randi_range(-1, 1)	
	
	if Utils.get_smoke_cell(global_position - Vector2(0, 150)) == null:
		just_saved()

func get_moves():
	velocity.x = get_walk_speed() * move_desire
	
func handle_animation():
	super.handle_animation()
	if is_held():
		velocity.y = 0
		position.y = 150
		position.x = -25
		rotation = 0
		play_animation("carried")
	
	else:
		if lung_health > 0.9:
			walk_index = 0
		elif lung_health > 0.5:
			walk_index = 1
		else:
			walk_index = 2

func is_held() -> bool:
	return $Area2D.is_held()

func just_saved():
	saved = true
	$ToolTip.text = "Saved!"
