extends Interactable
class_name CarvingInterationZone

signal carved_symbol(symbol: int)
signal interaction_ended()
var carving_state: bool = false

func carving_change(val: bool) -> void:
	if val: interaction_signal.emit()
	else: interaction_ended.emit()
	carving_state = val

func symbol_carved(symbol: int) -> void:
	if carving_state == true:
		carved_symbol.emit(symbol)
		print("InteractionZone: " + str(symbol))
