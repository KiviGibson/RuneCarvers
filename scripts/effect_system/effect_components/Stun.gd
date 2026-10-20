extends CustomNode
class_name Stun

@export var duration: float
var stunned: bool
func stun() -> void:
	host.stun()
	stunned = true

func un_stun() -> void:
	host.un_stun()
	stunned = false

func _process(delta: float) -> void:
	if not multiplayer.is_server() or not stunned: return
	duration -= delta
	if duration <= 0.0:
		un_stun()
