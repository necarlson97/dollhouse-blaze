extends Figure


var move_desire = 0

func _process(delta: float) -> void:
	if dead:
		move_desire = 0
		return
	if randf() < 0.001:
		move_desire = randi_range(-1, 1)	

func get_moves():
	velocity.x = WALK_SPEED * move_desire
