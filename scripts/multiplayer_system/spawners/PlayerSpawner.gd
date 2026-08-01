extends MultiplayerSpawner
class_name PlayerSapwner

const character_scene: PackedScene = preload("res://scenes/player/Player.tscn")
@export var game_overlay: Control
var _players: Dictionary[int, Player]
var current_pov: int = 0
@export var POV: Array[SubViewportContainer]
func _ready() -> void:
	spawn_function = spawn_player

func spawn_player(id: int) -> Player:
	var tmp: Player = character_scene.instantiate()
	tmp.owner_id = id
	tmp.name = "Player" + str(id)
	tmp.input_system.owner_id = id
	tmp.carving_ui.name += str(id)
	tmp.carving_ui.reparent(game_overlay) # Robi warning ale jest git
	tmp.view.reparent(POV[current_pov])
	current_pov += 1
	_players[id] = tmp
	return tmp

func get_player(id: int) -> Player: return _players[id]
func get_player_ids() -> Array[int]: return _players.keys()

@rpc("any_peer", "call_local", "reliable")
func hide_unused_viewport() -> void:
	if multiplayer.is_server(): 
		POV[1].visible = !POV[1].visible
		var tmp := POV[0].get_child(0) as SubViewport
		tmp.size = Vector2(960*(1+int(!POV[1].visible)), 1080)
	else: 
		POV[0].visible = !POV[0].visible
		var tmp := POV[1].get_child(0) as SubViewport
		tmp.size = Vector2(960*(1+int(!POV[0].visible)), 1080)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pov_change"):
		hide_unused_viewport.rpc()
