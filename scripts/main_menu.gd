extends Node2D

	
func tutorial():
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

func level_easy():
	get_tree().change_scene_to_file("res://scenes/level easy.tscn")
	
func level_medium():
	get_tree().change_scene_to_file("res://scenes/level medium.tscn")

func level_hard():
	get_tree().change_scene_to_file("res://scenes/level hard.tscn")
