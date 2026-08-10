extends OnHit
class_name BonusDamage

@export var stacks: int = 0
@export var flat: int = 0
@export var reset: bool
@export var timer: Timer

var current_stacks: int = 0

func gain_stack() -> void:  current_stacks += stacks
func wipe_stacks() -> void: current_stacks = 0

func alter_damage(hitbox: HitBox) -> void:
	hitbox.damage.value += flat + current_stacks
	print("Bonus Damage: " + str(current_stacks))
	if reset and timer.is_stopped():
		timer.start()
