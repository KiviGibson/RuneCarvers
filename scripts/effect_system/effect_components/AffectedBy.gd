extends CustomNode
class_name AffectedBy

signal is_affected()
signal is_not_affected()

@export var effect: StringName
@export var remove_effect: bool


func check_is_affected(_n: StringName = "") -> void: 
	print("Affect check")
	if not host: return
	print("Host exist")
	if host.is_affected(effect): 
		is_affected.emit()
		print("Affected")
		if remove_effect:
			host.remove_effect(effect)
	else: 
		print("Not affected")
		is_not_affected.emit()
