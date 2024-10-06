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
	if abs(velocity.x) <= get_walk_speed() * move_desire:
		velocity.x = get_walk_speed() * move_desire
	
func handle_animation():
	super.handle_animation()
	if is_held():
		velocity.y = 0
		position.y = 150
		var player = $Area2D.get_holding_player()
		if player.get_walk_state() == "crouch":
			position.y = 200
		elif player.get_walk_state() == "crawl":
			position.y = 300	
		position.x = -25
		rotation = 0
		play_animation("carried")
		walk_index = 2
	
	else:
		if lung_health > 0.9:
			walk_index = max(0, walk_index)
		elif lung_health > 0.5:
			walk_index = max(1, walk_index)
		else:
			walk_index = max(2, walk_index)

func is_held() -> bool:
	return $Area2D.is_held()

func just_saved():
	saved = true
	$ToolTip.text = "Saved!"
