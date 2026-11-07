extends CascadingEscapableUI

@export var press_to_proceed: GetUserInputDevice
@export var menu: Panel
@export var settings: Panel
@export var skip_menu: bool
func show_menu() -> void: 
	print("== M3NU ==")
	menu.visible = true
	if skip_menu: Lobby.create_game()

func show_options() -> void:
	print("== SEXTINGS ==")
	settings.visible = true

func _ready() -> void:
	EscapeManager.currently_cancellable_ui = self

func close() -> bool:
	var i := 0 
	for element in queue:
		i += 1
		if element.visible:
			element.visible = false
			if i == len(queue): press_to_proceed.visible = true
			return false
	return false

func _input(event: InputEvent) -> void:
	if press_to_proceed.visible: return
	if Options.good_input_device(event.device):
		EscapeManager.input(event)
