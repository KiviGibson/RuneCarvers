extends Unit
class_name Enemy

signal setup(unit: Unit)
@export var hp_bar: HpBar
@export var ai: EnemyAI

func _ready() -> void:
	super._ready()
	if not multiplayer.is_server(): return
	setup.emit(self)

func _on_health_change(curernt: int, absolute: int) -> void:
	if not multiplayer.is_server(): return
	hp_bar.health_change.rpc(curernt, absolute)

func _on_health_depleated() -> void: 
	if multiplayer.is_server():
		self.queue_free()

func stun() -> void: if ai: ai.on_stun()
func un_stun() -> void: if ai: ai.on_un_stun()
