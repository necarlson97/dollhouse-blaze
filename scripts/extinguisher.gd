extends Node2D

var fuel = 1.0
var squirt_timer = 0

func _input(event: InputEvent) -> void:
	if !is_held():
		return
	if Input.is_action_pressed("use_item"):
		squirt()

func _process(delta: float) -> void:
	if squirt_timer > 0:
		squirt_timer -= 1
	else:
		$"squirt particles".emitting = false

func squirt():
	if fuel <= 0:
		return
	for area in $SquirtArea.get_overlapping_areas():
		if area.get_parent().is_in_group("flame"):
			area.get_parent().size *= 0.9
	fuel -= 0.1
	fuel = clamp(fuel, 0, 1)
	$"squirt particles".emitting = true
	$ProgressBar.value = fuel
	squirt_timer = 10

func is_held() -> bool:
	return $Area2D.is_held()
