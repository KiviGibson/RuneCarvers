extends EscapableUI
class_name CascadingEscapableUI
@export var queue: Array[Control]

func close() -> bool:
	for element in queue:
		if element.visible:
			element.visible = false
			return false
	closed.emit()
	self.visible = false
	return true
