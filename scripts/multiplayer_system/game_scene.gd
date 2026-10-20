extends Node
var lock: bool = false
@export var list_of_view: Array[SubViewportContainer]
func _ready() -> void:
	Lobby.player_loaded.rpc_id(1)

func start_game(client_id: int) -> void:
	if lock: return 
	lock = true
	var tmp: Player = Players.spawn(1)
	tmp.global_position = Vector3(randf_range(-2, 2),1,0)
	tmp = Players.spawn(client_id)
	tmp.global_position = Vector3(randf_range(-2, 2),1,0)
