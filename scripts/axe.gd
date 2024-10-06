extends Node2D

func _input(event: InputEvent) -> void:
	if !is_held():
		return
	if Input.is_action_just_pressed("use_item"):
		smash()
		
func smash():
	var b = nearby_breakable()
	if b != null:
		b.punch(5)

func nearby_breakable():
	for body in $BreakArea.get_overlapping_bodies():
		var breakable = body.get_parent().get_node_or_null("Breakable")
		if breakable != null:
			return breakable
	return null

func is_held() -> bool:
	return $Area2D.is_held()
