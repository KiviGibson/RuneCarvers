extends Node
class_name Escape

var currently_cancellable_ui: EscapableUI: set = set_cancelable_ui
@export var escape_menu: EscapableUI

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		print("Close")
		if currently_cancellable_ui == null:
			currently_cancellable_ui = escape_menu
			escape_menu.visible = true
			return
		if currently_cancellable_ui.close():
			currently_cancellable_ui = null


func set_cancelable_ui(value: EscapableUI) -> void:
	if currently_cancellable_ui != null:
		while not currently_cancellable_ui.close(): pass
	currently_cancellable_ui = value
