extends Node2D

@export var health = 5

func _process(delta: float) -> void:
	$Health.scale *= Vector2(0.9, 0.9)

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
	get_parent().forced_open()
	get_parent().get_node("Broken").show()
