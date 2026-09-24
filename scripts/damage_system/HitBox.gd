extends Area3D
class_name HitBox

signal hit(collider: HurtBox)

@export var damage: Damage
@export var effects: Array[StringName]
@export var ticking: bool = false

func _ready() -> void:
	if not ticking: area_entered.connect(_on_hurtbox_collision)

func _on_hurtbox_collision(collider: HurtBox) -> void:
	if not multiplayer.is_server(): return
	collider.hit(damage, effects)
	hit.emit(collider)

func _damage_ownership_exchange(unit: Unit) -> void:
	damage = damage.duplicate(true)
	unit.set_damage_owner(self)

func tick() -> void:
	for collider in get_overlapping_areas():
		if collider is HurtBox:
			collider.hit(damage, effects)
