extends Unit
class_name Enemy

@export var hp_bar: HpBar

func _on_health_change(curernt: int, absolute: int) -> void:
	if not multiplayer.is_server(): return
	hp_bar.health_change.rpc(curernt, absolute)

func _on_health_depleated() -> void: pass
