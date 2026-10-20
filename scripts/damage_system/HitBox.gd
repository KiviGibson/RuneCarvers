extends Area3D
class_name HitBox

signal hit(collider: HurtBox)

@export var damage: Damage
@export var effects: Array[StringName]
@export var ticking: bool = false
@export var applies_knockback: bool
@export var displacement_vector: Vector3
@export var distance: float
func _ready() -> void:
	if not ticking: area_entered.connect(_on_hurtbox_collision)

func _on_hurtbox_collision(collider: HurtBox) -> void:
	if not multiplayer.is_server(): return
	collider.hit(damage, effects)
	hit.emit(collider)
	if applies_knockback: knockback(collider)

func _damage_ownership_exchange(unit: Unit) -> void:
	damage = damage.duplicate(true)
	unit.set_damage_owner(self)

func tick() -> void:
	for collider in get_overlapping_areas():
		if collider is HurtBox:
			collider.hit(damage, effects)
			if applies_knockback: knockback(collider)

func knockback(hurt: HurtBox) -> void:
	var d := self.global_basis*displacement_vector
	print("Applied knockback: " + hurt.name)
	hurt.get_displacement(d, distance)
