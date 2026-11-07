extends Node3D
class_name Effect

const str_to_path: Dictionary[StringName, String] = {
	&"positively_charged": "uid://dbh4fo4orvnbx",
	&"negatively_charged": "uid://d326cvvglkvbh",
	&"burn": "uid://cia21gmitmeip",
	&"fire_starter": "uid://dncupmnjuscno",
	&"fired_up": "uid://difcoya6deoe4",
	&"dazed": "uid://dkqnl2jcb08y8",
	&"rocky_armor": "uid://lg3p3chp0b4q",
	&"frostbite": "uid://oty8rbud34tw",
}

signal effect_expired(name: StringName)
signal on_expire()
signal effect_reset()
signal setup(host: Unit)

var effect_name: StringName
@export var duration: float
@export var temporary: bool = true
@export var exhausted: bool = false
@export var on_hit: Array[OnHit]
@export var on_hurt: Array[OnDamageRecieve]

var owner_unit: Unit
var host: Unit
var time_left: float 

func _ready() -> void:
	if not multiplayer.is_server(): return
	time_left = duration
	setup.emit(host)

func _process(delta: float) -> void:
	if not multiplayer.is_server(): return
	if not temporary: return
	time_left -= delta
	if time_left <= 0.0: 
		on_expire.emit()
		effect_expired.emit(effect_name)

func reset_cd() -> void:
	if not multiplayer.is_server() or exhausted: return
	time_left = duration
	effect_reset.emit()

func trigger_onhit(hitbox: HitBox) -> void:
	for h in on_hit:
		h.alter_damage(hitbox)

func trigger_onhurt(damage: Damage) -> void:
	for h in on_hurt:
		h.got_hit(damage)

func set_exhoust(val: bool, exhausted_duration: float = duration) -> void:
	exhausted = val
	time_left = exhausted_duration
