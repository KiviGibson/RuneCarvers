extends Area3D
class_name HurtBox

signal got_hit(damage: Damage)
signal affected(effect: StringName, owner_unit: Unit)
signal start_invincible_frames()
signal stop_invincible_frames()

var invincible_frames: float
var invincible: bool = false
@export var time_between_hits: float = 0.1

func _ready() -> void:
	if not multiplayer.is_server(): return
	got_hit.connect(func(dmg: Damage): if dmg.value > 10: _set_invincibility_frames(time_between_hits))
	stop_invincible_frames.connect(func(): print("Inv Stop"))
	start_invincible_frames.connect(func(): print("Inv Start"))

func hit(damage: Damage, effects: Array[StringName]= []) -> void:
	if not multiplayer.is_server(): return
	if invincible: return
	got_hit.emit(damage)
	for effect in effects:
		affected.emit(effect, damage.owner)

func _set_invincibility_frames(time: float) -> void:
	invincible_frames = time
	invincible = true
	start_invincible_frames.emit()

func _process(delta: float) -> void:
	if not multiplayer.is_server(): return
	if invincible:
		if invincible_frames <= 0.0:
			invincible = false
			stop_invincible_frames.emit()
		invincible_frames -= delta
