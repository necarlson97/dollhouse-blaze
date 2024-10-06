extends CellConnector

var is_open = false
var is_locked = false
var health = 5

@export var force_unlocked = false
@export var force_locked = false

func _ready() -> void:
	if force_locked:
		lock()
	elif force_unlocked:
		unlock()
	elif randf() < 0.1:
		lock()

func _process(delta: float) -> void:
	$Health.scale *= Vector2(0.9, 0.9)

func _input(event: InputEvent) -> void:
	if !is_alive():
		return
	if Input.is_action_just_pressed("use_item"):
		for body in $DoorArea.get_overlapping_bodies():
			if body.is_in_group("player"):
				if is_locked:
					var hurt_dict = {
						"axe": 5,
						"extinguisher": 3,
						"hand": 1,
					}
					var hurt_door = 1
					if body.held_str() in hurt_dict:
						hurt_door = hurt_dict[body.held_str()]
					punch(hurt_door)
					
					# Player also hurts themselves a bit
					if body.held_str() == "hand":
						body.hurt(0.02)
				else:
					toggle()
			
		
func toggle():
	if is_open:
		close()
	else:
		open()
	
func close():
	is_open = false
	get_node("RigidBody2D/CollisionShape2D").disabled = false
	$DoorClosed.show()
	$DoorOpen.hide()
	propegation_rate = 0.2

func open():
	is_open = true
	get_node("RigidBody2D/CollisionShape2D").disabled = true
	$DoorClosed.hide()
	$DoorOpen.show()
	$Locked.hide()
	propegation_rate = 0.9
	
func lock():
	close()
	is_locked = true
	$Locked.show()
	
func unlock():
	close()
	is_locked = false
	$Locked.hide()

func punch(hurt=1):
	if !is_alive():
		return

	$GPUParticles2D.emitting = true
	$GPUParticles2D.restart()
	health -= hurt
	health = clamp(health, 0, 10)
	if !is_alive():
		smash_open()
	$Health.scale = Vector2(1, 1)
	$Health.get_node("HealthLabel").text = "%s"%health
	
func is_alive():
	return health > 0

func smash_open():
	open()
	get_node("DoorArea/CollisionShape2D").disabled = true
	is_locked = true
	$DoorOpen.hide()
	$DoorSmashed.show()
