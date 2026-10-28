extends Resource
class_name NPCData

@export var display_name := "NPC"
@export var visual_model : PackedScene
@export var move_speed := 1.8
@export var wander_radius := 6.0
@export var idle_time_min := 2.0
@export var idle_time_max := 5.0
@export_file("*.json") var dialogue_path := ""
