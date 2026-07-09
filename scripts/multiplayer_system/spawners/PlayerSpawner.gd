extends MultiplayerSpawner

const character_scene: PackedScene = preload("res://scenes/player/Player.tscn")
@export var game_overlay: Control

func _ready() -> void:
	spawn_function = spawn_player

func spawn_player(id: int) -> Player:
	var tmp: Player = character_scene.instantiate()
	tmp.owner_id = id
	tmp.name = "Player" + str(id)
	tmp.input_system.owner_id = id
	tmp.carving_ui.name += str(id)
	tmp.carving_ui.reparent(game_overlay) # Spawn instead reparent
	return tmp
