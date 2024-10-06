extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var p = get_parent().get_node("player")
	var m = get_parent().get_node("magnifier")
	var d = get_parent().get_node("dollhouse")
	
	var x = (randi_range(0, d.ROOMS-1) + 0.5) * d.SIZE
	var y = (randi_range(0, d.FLOORS-1)) * -d.SIZE
	p.position = d.global_position + Vector2(x, y)
	print("Placed player at: %s"%p.position)
	
	x = (randi_range(0, d.ROOMS-1) + 0.5) * d.SIZE
	y = (randi_range(1, d.FLOORS-1) - 0.5) * -d.SIZE
	m.position = d.global_position + Vector2(x, y)
	print("Magnifier player at: %s"%m.position)
