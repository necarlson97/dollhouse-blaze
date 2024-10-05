extends Node2D

@export var waiting = false

var escape_vector = null
func _ready() -> void:
	$Magnifier.position = Vector2(randf_range(-3000, -2000), randf_range(-3000, -2000))

func _process(delta: float) -> void:
	if waiting:
		return 
		
	if escape_vector:
		$Magnifier.position = lerp($Magnifier.position, escape_vector, delta * 0.5)
	elif $Magnifier.position.length() < 10:
		spawn_fire()
		escape_vector = Vector2(randf_range(2000, 3000), randf_range(2000, 3000))
	else:
		$Magnifier.position = lerp($Magnifier.position, Vector2.ZERO, delta * 0.5)

func spawn_fire():
	var flame = preload("res://scenes/flame.tscn").instantiate()
	flame.global_position = global_position
	get_parent().add_child(flame)
