@abstract
extends Node3D
class_name Unit

@export var model: MovementControler
@export var stats: Stats
@export var hurt_box: HurtBox
var effects: Dictionary[StringName, Effect]
@export var effect_spawner: EffectSpawner
@export var projectile_spawner: ProjectileSpawner

@abstract func _on_health_change(curernt: int, max_value: int) -> void
@abstract func _on_health_depleated() -> void
var base_layer:= 2
var base_mask := 3

func _ready() -> void:
	if not multiplayer.is_server(): return
	setup_stats()
	if model: setup_movement()

func setup_stats() -> void:
	stats = stats.duplicate(true)
	stats.current_health = stats.max_health
	stats.health_changed.connect(_on_health_change)
	stats.health_depleated.connect(_on_health_depleated)

func setup_movement() -> void:
	model.setup_movement(
		stats.movement_speed, 
		stats.running_multiplayer,
		stats.focus_speed,
		stats.stamina
		)

func _on_getting_hit(damage: Damage) -> void:
	for key in effects.keys():
		effects[key].trigger_onhurt(damage)
	stats.current_health -= damage.value

func set_damage_owner(hitbox: HitBox): 
	hitbox.damage.owner = self
	for key in effects.keys():
		effects[key].trigger_onhit(hitbox)

func add_passive(passive: String) -> void:
	var tmp := effect_spawner.spawn({"type": "passive", "effect": passive, "owner": self})
	effects[tmp.name] = tmp

func add_effect(effect: StringName, owner_unit: Unit) -> void:
	if is_affected(effect):
		reset_cd(effect)
	else:
		var tmp: Effect = effect_spawner.spawn({"type": "status","effect": effect, "owner": owner_unit})
		effects[effect] = tmp
		tmp.effect_expired.connect(remove_effect)

func remove_effect(effect: StringName) -> void:
	if not multiplayer.is_server(): return
	if not is_affected(effect): return
	print("Removed Effect: " + effect)
	effects[effect].queue_free()
	effects.erase(effect)

func is_affected(effect: StringName) -> bool:
	return effect in effects.keys()

func reset_cd(effect: StringName) -> void:
	effects[effect].reset_cd()

func add_projectile(projectile: PackedScene) -> Projectile:
	var tmp := projectile_spawner.spawn({"scene": projectile.resource_path, "position": Vector3(0,0,0)})
	tmp.owning_unit = self
	return tmp

func disable_collision() -> void:
	model.collision_mask = 0
	model.collision_layer = 0

func enable_collision() -> void:
	model.collision_mask = base_mask
	model.collision_layer = base_layer
