extends CustomNode
class_name Teleport


func teleport_to_position(pos: Vector3 = Vector3.ZERO) -> void:
	host.model.global_position = pos
