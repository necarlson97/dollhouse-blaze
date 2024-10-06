extends Node2D

func open_connector():
	var conn = Utils.get_connector_at_pos(global_position + Vector2(200, 0))
	conn.propegation_rate = 0.8

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_down"):
		for body in $"Stair Up".get_overlapping_bodies():
			if body.is_in_group("player"):
				go_down(body)
	if Input.is_action_just_pressed("move_up"):
		for body in $"Stair Down".get_overlapping_bodies():
			if body.is_in_group("player"):
				go_up(body)
			

func go_up(player):
	player.global_position = $"Stair Up".global_position + Vector2(200, 0)
	player.skip_jump = true
func go_down(player):
	player.global_position = $"Stair Down".global_position + Vector2(200, 0)
