extends Node2D


var size = 1
# TODO is there ever a reason fires grow faster?
const GROWTH = 0.001

var cell = null

var min_spread_frames = 100
var max_spread_frames = 700
var to_spread = randi_range(min_spread_frames, max_spread_frames)

func _ready() -> void:
	set_cell()
	
func set_cell():
	# Get the smoke cell I belong to (if any)
	cell = Utils.get_smoke_cell(global_position)
	if cell == null:
		print("Could not find cell for %s"%self)
		
var die_timer = -1
func _process(delta: float) -> void:
	# if it was extinguished
	if die_timer > 0:
		die_timer -= 1
		scale *= 0.9
		if die_timer == 0:
			queue_free()
		return
	if size < 1:
		die()
	size += GROWTH
	size = clamp(size, 1, 5)
	scale = Vector2(size, size)
	
	if cell != null:
		cell.add_smoke()
	
	to_spread -= 1
	if to_spread <= 0:
		spread()

func _physics_process(delta: float) -> void:
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("toy"):
			body.hurt(0.001)

func spread():
	# Find a close flamable object, and create a new fire there
	# TODO don't create too many fires in the same cell, prefer to spread
	# to new cells
	to_spread = randi_range(min_spread_frames, max_spread_frames)
	var new_pos = global_position + Vector2(randf_range(-200, 200), randf_range(-200, 200))
	var sc = Utils.get_smoke_cell(new_pos)
	if sc == null:
		return
	var flames_in_cell = sc.get_children().filter(func(c): return "flame" in c.name).size()
	if flames_in_cell >= 10:
		return
	var new_flame = preload("res://scenes/flame.tscn").instantiate()
	sc.add_child(new_flame)
	new_flame.global_position = new_pos
	new_flame.name = "flame %s"%flames_in_cell

func die():
	die_timer = 200
	$"fire particles".emitting = false
	$"spark particles".emitting = false
	$"smoke particles".emitting = false
