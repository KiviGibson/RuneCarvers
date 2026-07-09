extends Resource
class_name Stats

signal health_changed(current: int, max_value: int)
signal health_depleated()
signal leveled_up()

@export var lvl: int = 10
var lvl_exp_treshold: int
var expirience: int: set = _set_expirience
var stat_points: int = 0

@export var dexterity: int = 5
@export var inteligence: int = 5
@export var vitality: int = 5

var max_health: int
var current_health: int: set = _set_health

func _set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	health_changed.emit(current_health, max_health)
	if current_health == 0: health_depleated.emit()

func _set_expirience(value: int) -> void:
	expirience = value
	if expirience >= lvl_exp_treshold:
		level_up()

func calculate_max_health() -> int:
	return vitality * 5 + inteligence + dexterity * 2

func calculate_next_exp() -> int:
	return int(10 * pow(lvl, 1.1))

func level_up() -> void:
	lvl += 1
	stat_points += 1
	var th := lvl_exp_treshold
	lvl_exp_treshold = calculate_next_exp()
	leveled_up.emit()
	expirience -= th
