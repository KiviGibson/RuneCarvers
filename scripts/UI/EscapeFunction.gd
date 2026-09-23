extends Node
class_name Escape

var currently_cancellable_ui: EscapableUI: set = set_cancelable_ui
@export var escape_menu: EscapableUI
@export var canvas: CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if currently_cancellable_ui == null:
			if event is not InputEventKey: return
			currently_cancellable_ui = escape_menu
			escape_menu.visible = true
			return
		if currently_cancellable_ui.close():
			currently_cancellable_ui = null
	if event.is_action_pressed("escape_menu"):
		if currently_cancellable_ui == escape_menu:
			currently_cancellable_ui = null
		else:
			currently_cancellable_ui = escape_menu
			escape_menu.visible = true


func set_cancelable_ui(value: EscapableUI) -> void:
	if currently_cancellable_ui != null:
		while not currently_cancellable_ui.close(): pass
		currently_cancellable_ui.z_index = 1
	currently_cancellable_ui = value
	if value:
		currently_cancellable_ui.z_index = 2
