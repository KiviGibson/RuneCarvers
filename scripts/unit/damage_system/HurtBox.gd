extends Area3D
class_name HurtBox

signal dealt_damage(damage_value: int)
signal status_applied()

func deal_damage(damage_value: int) -> void:
	dealt_damage.emit(damage_value)

func aply_status() -> void:
	status_applied.emit()
