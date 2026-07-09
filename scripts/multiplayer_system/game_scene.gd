extends Node

@export var game_overlay: Control
@export var player_spawner: MultiplayerSpawner

func _ready() -> void:
	Lobby.player_loaded.rpc_id(1)

func start_game(client_id: int) -> void:
	var tmp := player_spawner.spawn(1)
	tmp.global_position = Vector3(randf_range(-2, 2),1,0)
	tmp = player_spawner.spawn(client_id)
	tmp.global_position = Vector3(randf_range(-2, 2),1,0)
