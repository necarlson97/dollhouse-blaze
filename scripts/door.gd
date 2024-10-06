extends CellConnector

var is_open = false
var is_locked = false

@export var force_unlocked = false
@export var force_locked = false

func _ready() -> void:
	if force_locked:
		lock()
	elif force_unlocked:
		unlock()
	elif randf() < 0.1:
		lock()

func _input(event: InputEvent) -> void:
	if !$Breakable.is_alive():
		return
	if Input.is_action_just_pressed("use_door"):
		for body in $DoorArea.get_overlapping_bodies():
			if body.is_in_group("player"):
				if !is_locked:
					toggle()
				else:
					var hurt_dict = {
						"axe": 5,
						"extinguisher": 3,
						"hand": 1,
					}
					var hurt_door = 1
					if body.held_str() in hurt_dict:
						hurt_door = hurt_dict[body.held_str()]
					$Breakable.punch(hurt_door)
					
					# Player also hurts themselves a bit
					if body.held_str() == "hand":
						body.hurt(0.02)
		
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

func forced_open():
	open()
	get_node("DoorArea/CollisionShape2D").disabled = true
	$DoorOpen.hide()
