extends CanvasLayer

var end_triggered = false
var fire_started = false

func _input(event):
	if event.is_action_pressed("escape"):
		visible = !visible
		get_tree().paused = visible
		
func _process(delta: float) -> void:
	if end_triggered:
		return
	var all = get_tree().get_nodes_in_group("friend")
	var saved = all.filter(func(f): return f.saved).size()
	var dead = all.filter(func(f): return f.dead).size()
	if all.size() > 0 && saved + dead >= all.size():
		make_visible()
		if saved > dead:
			$Control/VBoxContainer/Label.text = "You did it!"
		else:
			$Control/VBoxContainer/Label.text = "Many died..."
		end_triggered = true
	
	var player = get_tree().get_first_node_in_group("player")
	if player.dead:
		make_visible()
		$Control/VBoxContainer/Label.text = "You died."
		end_triggered = true
	
	var flames = get_tree().get_nodes_in_group("flame")
	if flames.size() > 0:
		fire_started = true
	if flames.size() == 0 and fire_started:
		make_visible()
		$Control/VBoxContainer/Label.text = "Fire defeated!"
		end_triggered = true

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
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func tutorial():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
