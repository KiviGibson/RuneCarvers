extends Node3D
class_name JackSmith

@export var interaction_zone: Interactable

	
func open_inventory(player_id: int) -> void:
	var player: Player = Players.get_player(player_id)
	player.inventory.swap_visibility.rpc_id(player_id, true)

func close_inventory(player_id: int) -> void:
	var player: Player = Players.get_player(player_id)
	player.inventory.swap_visibility.rpc_id(player_id,false)
