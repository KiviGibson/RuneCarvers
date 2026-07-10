extends Area3D
class_name HitBox

@export var damage: Damage

func _ready() -> void:
	area_entered.connect(_on_hurtbox_collision)

func _on_hurtbox_collision(collider: HurtBox) -> void:
	collider.hit(damage)
