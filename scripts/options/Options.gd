extends Node

enum input_device{controller, mouse_keyboard}
var device: input_device
var device_id: int = -1

func good_input_device(id: int) -> bool:
	if device == input_device.mouse_keyboard: return id in [16, 32]
	else: return device_id == id
