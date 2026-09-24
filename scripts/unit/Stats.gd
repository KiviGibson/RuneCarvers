extends Resource
class_name Stats

signal health_changed(current: int, max_value: int)
signal health_depleated()

@export var max_health: int
var current_health: int: set = _set_health

@export var stamina: float = 5.0
@export var movement_speed: float = 5.0
@export var running_multiplayer: float = 1.5
@export var focus_speed: float = 0.75

func _set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	health_changed.emit(current_health, max_health)
	if current_health == 0: health_depleated.emit()
