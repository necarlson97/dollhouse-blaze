extends ProgressBar

var good = Color.html('#d9ead3')
var bad = Color.html('#666666')
	
func _process(delta: float) -> void:
	var all = get_tree().get_nodes_in_group("friend")
	var saved = all.filter(func(f): return f.saved).size()
	var progress: float = float(saved) / float(all.size())
	progress = clamp(progress, 0.1, 1)
	modulate = bad.lerp(good, progress)
	value = progress
	$Label.text = "%s/%s Saved"%[saved, all.size()]
	#print("%s/%s %s (%s)"%[savedvalue)
	
