extends CharacterBody2D
class_name Figure

const GRAVITY = 2400.0
const WALK_SPEED = 300
const RUN_SPEED = 500
const DAMPENING = 0.8

const JUMP_FORCE = -800.0
const MAX_FALL_SPEED = 1200.0

var lung_health = 1.0
var blood_health = 1.0

var walk_states = [
	"walk", "crouch", "crawl"
]
var walk_index = 0

var animation_player: AnimationPlayer
func _ready() -> void:
	animation_player = $figure/AnimationPlayer

func _physics_process(delta):
	# Apply gravity and cap the fall speed
	if velocity.y < MAX_FALL_SPEED:
		velocity.y += delta * GRAVITY
	velocity.x *= DAMPENING

	get_moves()
	
	move_and_slide()
	handle_smoke()
	handle_animation()
	
func get_moves():
	pass

func handle_smoke():
	var cell = Utils.get_smoke_cell(global_position - Vector2(0, 150))
	if cell == null:
		lung_health += 0.001
	else:
		lung_health -= cell.ammount * 0.001
	lung_health = clamp(lung_health, 0, 1)
	
	$figure.modulate = Color.from_hsv(0, 1-blood_health, lung_health, 1)
	
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

func handle_animation():
	if is_on_floor():
		if abs(velocity.x) > WALK_SPEED:
			play_animation("run", velocity.x < 0)
		elif abs(velocity.x) > 10:
			play_animation(get_walk_state(), velocity.x < 0)
		else:
			play_animation("idle")
	
func play_animation(animation_name: String, reverse: bool = false):
	var matching_animation = animation_player.current_animation == animation_name
	var matching_speed = (animation_player.speed_scale == -1) == reverse
	if !(matching_animation and matching_speed):
		if reverse:
			animation_player.speed_scale = -1
		else:
			animation_player.speed_scale = 1
		animation_player.play(animation_name)
func get_walk_state():
	return walk_states[walk_index]
