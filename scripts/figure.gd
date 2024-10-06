extends CharacterBody2D
class_name Figure

const GRAVITY = 2400.0
const DAMPENING = 0.8

const RUN_SPEED = 700
var WALK_SPEEDS = [
	350, 275, 200
]

const JUMP_FORCE = -800.0
const MAX_FALL_SPEED = 1200.0

var lung_health = 1.0
var blood_health = 1.0
var WALK_SMOKE_ABSORBTION = [
	1.0, 0.5, 0.2
]

var walk_states = [
	"walk", "crouch", "crawl"
]
var walk_index = 0

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
	
	var base_ammount = 0.001
	var modifier = WALK_SMOKE_ABSORBTION[walk_index]
	if is_running():
		modifier = 1.5
		
	if cell == null:
		lung_health += 0.001
	else:
		lung_health -= cell.ammount * 0.001 * modifier
	lung_health = clamp(lung_health, 0, 1)
	
	$figure/AnimatedSprite2D.modulate = Color.from_hsv(0, 1-blood_health, lung_health, 1)
	
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
		$ToolTip.text = "Choked on smoke."
	if blood_health <= 0:
		$ToolTip.text = "Blead out."
	$ToolTip.position.y = -250

func handle_animation():
	if dead:
		play_animation("dead")
		return
	
	if !is_on_floor() and get_walk_state() != "crawl":
		play_animation("falling")
		return
		
	if is_running() and get_walk_state() != "crawl":
		play_animation("run")
	elif abs(velocity.x) > 10:
		play_animation(get_walk_state())
	else:
		play_animation("idle %s"%get_walk_state())
	
	if velocity.x < 0:
		$figure.scale.x = -1
	elif velocity.x > 0:
		$figure.scale.x = 1
	
	
	
var animations = {
	"idle walk": preload("res://assets/player idle.tres"),
	"idle crouch": preload("res://assets/player idle crouch.tres"),
	"idle crawl": preload("res://assets/player idle crawl.tres"),
	
	"walk": preload("res://assets/player walk.tres"),
	"run": preload("res://assets/player run.tres"),
	"crouch": preload("res://assets/player crouch.tres"),
	"crawl": preload("res://assets/player crawl.tres"),
	
	"carried": preload("res://assets/player carried.tres"),
	"dead": preload("res://assets/player dead.tres"),
	"falling": preload("res://assets/player falling.tres"),
}
func play_animation(animation_name: String):
	var anim = $figure/AnimatedSprite2D
	if anim.sprite_frames != animations[animation_name]:
		anim.sprite_frames = animations[animation_name]
		anim.play()
	
func get_walk_state():
	return walk_states[walk_index]

func get_walk_speed():
	return WALK_SPEEDS[walk_index]
	
func is_running() -> bool:
	return abs(velocity.x) > WALK_SPEEDS[0]
