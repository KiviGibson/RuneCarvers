extends Interactable
class_name CarvingInterationZone

signal carved_symbol(symbol: int)
signal interaction_ended()
@export var code_handler : CodeHandler
var carving_state: bool = false

func carving_change(val: bool) -> void:
	print_debug("carving : ", val)
	if val: interaction_signal.emit()
	else: interaction_ended.emit()
	carving_state = val

func symbol_carved(symbol: int) -> void:
	if carving_state == true:
		carved_symbol.emit(symbol)
