extends Area3D
class_name Interactable

signal interaction_signal(player_id: int)
signal unit_out_of_range(player_id: int)
@export var unit_limit: int = 2
@export var overlay: Node3D
@export var interaction_timer: Timer

var can_interact: bool = true
var units_interacting: int = 0

func can_connect() -> bool:
	return unit_limit > units_interacting

func connect_unit(id: int) -> void:
	units_interacting = clampi(units_interacting + 1, 0, unit_limit)
	show_overlay.rpc_id(id, true)

func disconnect_unit(id: int) -> void:
	units_interacting = clampi(units_interacting - 1, 0, unit_limit)
	show_overlay.rpc_id(id, false)
	unit_out_of_range.emit(id)

@rpc("authority", "call_local", "reliable")
func show_overlay(_val: bool) -> void: pass

func interaction_call() -> void: 
	if not can_interact: return 
	interaction_signal.emit(multiplayer.get_remote_sender_id())
