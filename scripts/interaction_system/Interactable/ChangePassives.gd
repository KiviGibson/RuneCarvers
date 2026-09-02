extends Node3D
class_name BuildChanger

@export var effect_list: Array[StringName]

func remove_all_effects(unit: Unit) -> void:
	for key in unit.effects.keys():
		unit.remove_effect(key)

func give_effects(unit: Unit) -> void:
	for effect_name in effect_list:
		unit.add_passive(effect_name)

func set_player_gems(player_id: int) -> void:
	var unit := Players.get_player(player_id)
	remove_all_effects(unit)
	give_effects(unit)
