extends OnDamageRecieve
class_name Resist

@export var blocked_damage_types: Array[Damage.type]
@export var amount_flat: int
 
func got_hit(damage: Damage) -> void:
	if damage.damage_type in blocked_damage_types:
		damage.value = clampi(damage.value-amount_flat, 1, damage.value)
