extends StaticBody3D
class_name Hole

var used: bool = false
var player_near: bool = false
@export var player_range: Area3D



func _on_timer_timeout() -> void:
	player_near = false
	for unit in player_range.get_overlapping_bodies():
		if unit is Player: 
			player_near = true
			return
