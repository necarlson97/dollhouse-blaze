extends ProgressBar

var good = Color.html('#f4cccc')
var bad = Color.BLACK
	
func _process(delta: float) -> void:
	var progress = get_tree().get_first_node_in_group("player").lung_health
	progress = clamp(progress, 0, 1)
	modulate = bad.lerp(good, progress)
	value = progress
