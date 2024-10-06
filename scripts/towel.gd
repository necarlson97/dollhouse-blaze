extends RigidBody2D

var is_wet = false
var is_deployed = false
var was_held = false

func _input(event: InputEvent) -> void:
	if !is_held():
		return
	if Input.is_action_just_pressed("use_item"):
		if nearby_wettable() != null:
			wet()

func nearby_wettable():
	for area in $Wettable.get_overlapping_areas():
		if area is WetArea:
			return area
	return null

var visuals = {
	"dry": preload("res://assets/towel.png"),
	"wet": preload("res://assets/towel wet.png"),
	"dry ground": preload("res://assets/towel ground.png"),
	"wet ground": preload("res://assets/towel wet ground.png"),
}
func _process(delta: float) -> void:
	if wet_count <= 0:
		is_wet = false
	
	var s = "dry"
	if is_wet:
		s = "wet"
	if is_deployed && ! is_held():
		s += " ground"
	$Sprite2D.texture = visuals[s]
	
	if is_held():
		was_held = true
	elif was_held:
		deploy()

func wet():
	wet_count = 2
	is_wet = true

var wet_count = 0
func deploy():
	$CollisionShape2D.disabled = true
	is_deployed = true
	
	for body in $Wettable.get_overlapping_bodies():
		var p = body.get_parent()
		if wet_count <= 0:
			return
		if p is Door || p is Wall:
			p.modulate = Color.html("#c9daf8")
			p.propegation_rate = 0
			wet_count -= 1
		if p is Door:
			p.closed_rate = 0

func is_held() -> bool:
	return $Area2D.is_held()
