extends Node3D
class_name BuildChanger

@export var effect_list: Array[StringName]

func remove_all_effects(unit: Unit) -> void:
	unit.effects.clear()

func give_effects(unit: Unit) -> void:
	for effect_name in effect_list:
		unit.add_passive(effect_name)

func set_player_gems() -> void:
	var unit := Players.get_player(multiplayer.get_remote_sender_id())
	remove_all_effects(unit)
	give_effects(unit)
