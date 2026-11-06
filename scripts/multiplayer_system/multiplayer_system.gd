extends Node
class_name MultiplayerSystem

signal player_connected(peer_id: int)
@warning_ignore("unused_signal")
signal player_disconnnected(peer_id: int)

@export var port := 2137
@export var ip := "127.0.0.1" 
const max_connected := 2
var player_count := 0
var client: int
@export var text: Label
@export var debug_solo: bool

func _ready() -> void:
	player_connected.connect(player_joined)
	multiplayer.connected_to_server.connect(_on_player_connected_ok)
	multiplayer.peer_connected.connect(_player_connected)
	var args:= Array(OS.get_cmdline_args())
	if "--server" in args: 
		create_game(true)
		Options.device = Options.input_device.mouse_keyboard
	if "--client" in args: 
		join_game()
		Options.device = Options.input_device.controller
		Options.device_id = 0

func create_game(ignore_solo: bool = false) -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(port, max_connected)
	if error: return
	multiplayer.multiplayer_peer = peer
	player_connected.emit(1)
	text.text = str(1)
	if debug_solo and not ignore_solo:
		player_connected.emit(100)
		client = 100
		player_joined(100)
		player_loaded.rpc()
		Players.hide_unused_viewport.rpc()

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
	get_tree().change_scene_to_file(game_scene) # Zamienia menu na grę

@rpc("any_peer", "call_local", "reliable")
func player_loaded() -> void:
	if not multiplayer.is_server(): return
	player_count += 1
	if player_count == 2:
		$/root/Game.start_game(client)
		player_count = 0
