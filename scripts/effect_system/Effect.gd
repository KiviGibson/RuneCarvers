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
signal effect_reset()
signal setup(host: Unit)

var effect_name: StringName
@export var duration: float
@export var temporary: bool = true
@export var on_hit: Array[OnHit]
@export var on_hurt: Array[OnDamageRecieve]

var owner_unit: Unit
var host: Unit

var time_left: float 

func _ready() -> void:
	if not multiplayer.is_server(): return
	setup.emit(host)
	time_left = duration

func _process(delta: float) -> void:
	if not multiplayer.is_server(): return
	
	if not temporary: return
	time_left -= delta
	if time_left <= 0.0: effect_expired.emit(effect_name)

func reset_cd() -> void:
	effect_reset.emit()
	time_left = duration

func trigger_onhit(hitbox: HitBox) -> void:
	for h in on_hit:
		h.alter_damage(hitbox)

func trigger_onhurt(damage: Damage) -> void:
	for h in on_hurt:
		h.got_hit(damage)
