@abstract
extends Node3D
class_name Unit

@export var model: CharacterBody3D
@export var stats: Stats

@abstract func _on_health_change(curernt: int, max_value: int) -> void

func _ready() -> void:
	if not multiplayer.is_server(): return
	setup_stats()

func setup_stats() -> void:
	stats = stats.duplicate(true)
	stats.max_health = stats.calculate_max_health()
	stats.current_health = stats.max_health
	stats.lvl_exp_treshold = stats.calculate_next_exp()
	stats.health_changed.connect(_on_health_change)

func _on_getting_hit(damage_value: int) -> void:
	stats.current_health -= damage_value
