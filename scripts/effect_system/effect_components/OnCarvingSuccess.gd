extends CustomNode
class_name OnCarvingSuccess
  
signal carving_success()

func setup(h: Unit) -> void:
	super.setup(h)
	if host is Player:
		host.carving_system.successful_carving.connect(on_carving_success)

func on_carving_success(_rune: PackedScene = null) -> void:
	carving_success.emit()
