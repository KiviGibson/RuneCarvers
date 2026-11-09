extends Node2D
class_name ToolTrade

signal picked(dict: Dictionary)
# DATA
@export var button: Button
@export var label: Label
var is_owned_by_player: bool
var pos: int
var tool: Tool

func choose_option() -> void:
	print("pressed")
	picked.emit({
		"is_owned_by_player": is_owned_by_player,
		"pos": pos,
		"tool": tool,
	})

func set_tool(tool: Tool) -> void: pass
	
func _ready() -> void:
	button.pressed.connect(choose_option)
	label.text = str(randi())
