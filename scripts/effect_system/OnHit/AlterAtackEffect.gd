extends OnHit
class_name AlterEffect

enum type{remove_effect, add_effect, repleace_effect}

@export var remove: StringName
@export var add: StringName
@export var node_func: type

func add_effect(hitbox: HitBox) -> void:
	hitbox.effects.append(add)

func repleace_effect(hitbox: HitBox) -> void:
	if remove in hitbox.effects: 
		remove_effect(hitbox)
		add_effect(hitbox)

func remove_effect(hitbox: HitBox) -> void:
	hitbox.effects.erase(remove)

func alter_damage(hitbox: HitBox) -> void:
	match node_func:
		type.add_effect: add_effect(hitbox)
		type.remove_effect: remove_effect(hitbox)
		type.repleace_effect: repleace_effect(hitbox)
	print(hitbox.effects)
