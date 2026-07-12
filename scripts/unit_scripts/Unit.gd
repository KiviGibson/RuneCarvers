@abstract
extends Node3D
class_name Unit

@export var model: CharacterBody3D
@export var stats: Stats

@abstract func _on_health_change(curernt: int, max_value: int) -> void
@abstract func _on_health_depleated() -> void

func _ready() -> void:
	if not multiplayer.is_server(): return
	setup_stats()

func setup_stats() -> void:
	stats = stats.duplicate(true)
	stats.current_health = stats.max_health
	stats.health_changed.connect(_on_health_change)
	stats.health_depleated.connect(_on_health_depleated)

func _on_getting_hit(damage_value: int) -> void:
	stats.current_health -= damage_value
	print(stats.current_health)

func set_damage_owner(damage: Damage): 
	damage.owner = self
