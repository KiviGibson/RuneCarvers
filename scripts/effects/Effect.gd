extends Node3D
class_name Effect

const str_to_path: Dictionary[StringName, String] = {
	&"positively_charged": "uid://dbh4fo4orvnbx",
	&"negatively_charged": "uid://d326cvvglkvbh",
	&"burn": "uid://cia21gmitmeip"
}

signal effect_expired(name: StringName)
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
	time_left = duration

func trigger_onhit(hitbox: HitBox) -> void:
	for h in on_hit:
		h.alter_damage(hitbox)

func trigger_onhurt(damage: Damage) -> void:
	for h in on_hurt:
		h.got_hit(damage)
