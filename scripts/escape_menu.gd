extends CanvasLayer

func _input(event):
	if event.is_action_pressed("escape"):
		visible = !visible
		get_tree().paused = visible
		
func _process(delta: float) -> void:
	var all = get_tree().get_nodes_in_group("friend")
	var saved = all.filter(func(f): return f.saved).size()
	if saved >= all.size():
		make_visible()
		$Control/VBoxContainer/Label.text = "You did it!"

func make_visible():
	visible = true
	get_tree().paused = true

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func button_continue():
	visible = false
	get_tree().paused = false
	
func main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main menu.tscn")
	
func tutorial():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
