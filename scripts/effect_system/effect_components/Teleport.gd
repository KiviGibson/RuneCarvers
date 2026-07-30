extends CustomNode
class_name Teleport

@export var model: Node3D

func teleport_to_position(pos: Vector3 = Vector3.ZERO) -> void:
	if model: model.global_position = pos
	else: host.model.global_position = pos
