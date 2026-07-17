extends Area3D
class_name HitBox

signal hit(collider: HurtBox)

@export var damage: Damage
@export var effects: Array[StringName]

func _ready() -> void:
	area_entered.connect(_on_hurtbox_collision)

func _on_hurtbox_collision(collider: HurtBox) -> void:
	if not multiplayer.is_server(): return
	collider.hit(damage, effects)
	hit.emit(collider)

func _damage_ownership_exchange(unit: Unit) -> void:
	damage = damage.duplicate(true)
	damage.owner = unit
