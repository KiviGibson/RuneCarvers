extends OnHit
class_name BonusDamage

@export var stacks_increment: int = 0
@export var flat: int = 0
@export_range(0.0, 1.0, 0.05) var percent: float = 0.0
@export var reset: bool
@export var timer: Timer

var current_stacks: int = 0

func gain_stack() -> void:  current_stacks += stacks_increment
func wipe_stacks() -> void: current_stacks = 0

func alter_damage(hitbox: HitBox) -> void:
	hitbox.damage.value += flat + current_stacks + roundi(percent*hitbox.damage.value)
	if reset and timer.is_stopped():
		timer.start()
