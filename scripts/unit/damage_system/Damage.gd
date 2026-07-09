extends Resource
class_name Damage

var owner: Unit

@export var base_value: int = 1
@export var inteligence_scaling: float = 0.0
@export var vitality_scaling: float = 0.0
@export var dexterity_scaling: float = 0.0

func get_damage() -> int:
	var result := base_value
	result += int(inteligence_scaling * owner.stats.inteligence)
	result += int(dexterity_scaling * owner.stats.dexterity)
	result += int(vitality_scaling * owner.stats.vitality)
	return result
