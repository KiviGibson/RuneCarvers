extends CustomNode
class_name DamageUnit

signal deal_damage(damage)

@export var damage: Damage

func setup(h: Unit) -> void:
	super.setup(h)
	deal_damage.connect(host._on_getting_hit)

func on_tick() -> void:
	deal_damage.emit(damage)
