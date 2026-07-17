extends Node
class_name AffectedBy

signal is_affected()
signal is_not_affected()

var host: Unit
@export var effect: StringName
@export var remove_effect: bool
func setup(h: Unit) -> void: 
	host = h

func check_is_affected(_n: StringName = "") -> void: 
	if not host: return
	if host.is_affected(effect): 
		is_affected.emit()
		if remove_effect:
			host.remove_effect(effect)
	else: is_not_affected.emit()
