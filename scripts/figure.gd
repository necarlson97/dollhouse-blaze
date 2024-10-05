extends CharacterBody2D
class_name Figure

const GRAVITY = 2400.0
const WALK_SPEED = 400
const DAMPENING = 0.8

const JUMP_FORCE = -800.0
const MAX_FALL_SPEED = 1200.0

var lung_health = 1.0
var blood_health = 1.0

func _physics_process(delta):
	# Apply gravity and cap the fall speed
	if velocity.y < MAX_FALL_SPEED:
		velocity.y += delta * GRAVITY
	velocity.x *= DAMPENING

	get_moves()
	
	move_and_slide()
	handle_smoke()
	
func get_moves():
	pass

func handle_smoke():
	var cell = Utils.get_smoke_cell(global_position - Vector2(0, 150))
	if cell == null:
		lung_health += 0.001
	else:
		lung_health -= cell.ammount * 0.001
	lung_health = clamp(lung_health, 0, 1)
	
	$AnimatedSprite2D.modulate = Color.from_hsv(0, 1-blood_health, lung_health, 1)
	
	if blood_health <= 0 || lung_health <= 0:
		die()

func hurt(hurt=0.1):
	if dead:
		return
	blood_health -= hurt
	blood_health = clamp(blood_health, 0, 1)
	$BloodParticles.emitting = true
	$BloodParticles.restart()
	if blood_health <= 0:
		die()

var dead = false
func die():
	dead = true
	if lung_health <= 0:
		$ToolTip.text = "You choked on smoke."
	if blood_health <= 0:
		$ToolTip.text = "You blead out."
