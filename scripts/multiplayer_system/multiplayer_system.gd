extends Node

signal player_connected(peer_id: int)
signal player_disconnnected(peer_id: int)

const port := 2137
const ip := "127.0.0.1"
const max_connected := 2
var player_count := 0
var client: int
@export var text: Label

func _ready() -> void:
	player_connected.connect(player_joined)
	multiplayer.connected_to_server.connect(_on_player_connected_ok)
	multiplayer.peer_connected.connect(_player_connected)

func create_game() -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(port, max_connected)
	if error: return
	multiplayer.multiplayer_peer = peer
	player_connected.emit(1)
	text.text = str(1)

func join_game() -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(ip, port)
	if error: return
	multiplayer.multiplayer_peer = peer

func _on_player_connected_ok() -> void:
	text.text = str(multiplayer.get_unique_id())

func _player_connected(id: int) -> void:
	if not multiplayer.is_server(): return
	player_connected.emit(id)
	client = id
	
func player_joined(id: int) -> void:
	print("Player joined: " + str(id))
	if id == 1: return
	load_game.rpc("res://scenes/game_scene/game.tscn")

@rpc("call_local", "reliable")
func load_game(game_scene: String) -> void:
	get_tree().change_scene_to_file(game_scene)

@rpc("any_peer", "call_local", "reliable")
func player_loaded() -> void:
	if not multiplayer.is_server(): return
	player_count += 1
	if player_count == 2:
		$/root/Game.start_game(client)
		player_count = 0
