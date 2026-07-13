extends Node
class_name Rune
@warning_ignore("unused_signal")
signal setup(owning_unir: Unit)
signal activation()
signal empty()

@export var cd: float = 0.3
@export var ammo: int = 1
var current: float = 0.0
func activate(_value: bool) -> void:
	if current > 0: return
	ammo -= 1
	current = cd
	activation.emit()
	if ammo <= 0:
		empty.emit()

func _process(delta: float) -> void:
	if not multiplayer.is_server(): return
	current -= delta
