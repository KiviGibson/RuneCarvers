extends Node2D
class_name ToolTrade

signal picked(dict: Dictionary)
# DATA
var is_owned_by_player: bool
var pos: int
var tool: Tool

@rpc("any_peer", "call_local", "reliable")
func choose_option() -> void:
	picked.emit({
		"is_owned_by_player": is_owned_by_player,
		"pos": pos,
		"tool": tool,
	})

func _ready() -> void: pass
