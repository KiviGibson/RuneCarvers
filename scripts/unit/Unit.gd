@abstract
extends Node3D
class_name Unit

@export var model: MovementControler
@export var stats: Stats

var effects: Dictionary[StringName, Effect]
@export var effect_spawner: EffectSpawner

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

func add_effect(effect: StringName, owner_unit: Unit) -> void:
	if is_affected(effect):
		reset_cd(effect)
	else:
		var tmp: Effect = effect_spawner.spawn({"effect": effect, "owner": owner_unit})
		effects[effect] = tmp
		tmp.effect_expired.connect(remove_effect)

func remove_effect(effect: StringName) -> void:
	if not is_affected(effect): return
	effects[effect].queue_free()
	effects.erase(effect)

func is_affected(effect: StringName) -> bool:
	return effect in effects.keys()

func reset_cd(effect: StringName) -> void:
	effects[effect].reset_cd()
