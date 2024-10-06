extends ProgressBar

var good = Color.html('#e06666ff')
var bad = Color.WHITE
	
func _process(delta: float) -> void:
	var progress = get_tree().get_first_node_in_group("player").blood_health
	progress = clamp(progress, 0, 1)
	modulate = good.lerp(bad, progress)
	value = progress
