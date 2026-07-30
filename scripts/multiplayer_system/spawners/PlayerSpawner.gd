extends MultiplayerSpawner
class_name PlayerSapwner

const character_scene: PackedScene = preload("res://scenes/player/Player.tscn")
@export var game_overlay: Control
var _players: Dictionary[int, Player]

func _ready() -> void:
	spawn_function = spawn_player

func spawn_player(id: int) -> Player:
	var tmp: Player = character_scene.instantiate()
	tmp.owner_id = id
	tmp.name = "Player" + str(id)
	tmp.input_system.owner_id = id
	tmp.carving_ui.name += str(id)
	tmp.carving_ui.reparent(game_overlay) # Robi warning ale jest git
	_players[id] = tmp
	return tmp

func get_player(id: int) -> Player: return _players[id]
func get_player_ids() -> Array[int]: return _players.keys()
