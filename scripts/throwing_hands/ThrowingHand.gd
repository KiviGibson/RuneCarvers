extends Node
class_name ThrowingHands
@export var animator: AnimationPlayer
var base_damage: int
@export var max_charge_damage: float = 10.0
var current_hand: String = "right"
@export var hitbox: HitBox
@export var rune: Rune

func _ready() -> void:
	if not multiplayer.is_server(): return
	hitbox.damage = hitbox.damage.duplicate(true)
	base_damage = hitbox.damage.value
	animator.animation_finished.connect(on_atack_off)

func charging() -> void:
	if not multiplayer.is_server(): return
	play_animation.rpc(current_hand + "_charge")


func atack(charge_value:float) -> void:
	if not multiplayer.is_server(): return
	rune.ammo += 1
	hitbox.damage.value = base_damage + roundi(max_charge_damage*charge_value)
	play_animation.rpc(current_hand + "_atack")
	change_hand()

func on_atack_off(anim_name: String) -> void:
	if not multiplayer.is_server(): return
	if anim_name in ["left_atack", "right_atack"]:
		play_animation.rpc("idle")
		rune.ammo -= 1
		if rune.ammo <= 0:
			rune.emptied()

func change_hand() -> void:
	current_hand = "right" if current_hand == "left" else "left"
	
@rpc("authority", "call_local", "reliable")
func play_animation(anim_name: String) -> void:
	animator.play(anim_name)
