extends Control
class_name GetUserInputDevice

signal device_selected()

func _input(event: InputEvent) -> void:
	if not visible: return
	if not event.is_pressed():
		return
	Options.device_id = event.device
	if event.device in [16, 32]: Options.device = Options.input_device.mouse_keyboard
	else: Options.device = Options.input_device.controller
	device_selected.emit()
	visible = false
