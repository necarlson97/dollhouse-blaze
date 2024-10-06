extends Node2D

var level = 0
@export var room_set = -1
@export var floor_set = -1

func get_rooms():
	if room_set > 0:
		return room_set
	var min_floors = 6 + level*2
	var max_floors = 6 + level*2
	return randi_range(min_floors, max_floors)
	
func get_floors():
	if floor_set > 0:
		return floor_set
	var min_floors = 2 + level*2
	var max_floors = 3 + level*2
	return randi_range(min_floors, max_floors)
	
func get_friend_count():
	return (1+level) * 2
