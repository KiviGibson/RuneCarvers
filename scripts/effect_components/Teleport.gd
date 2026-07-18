extends Node3D
class_name Teleport

var host: Unit

func setup(h: Unit) -> void:
	host = h

func teleport_to_position(pos: Vector3 = Vector3.ZERO) -> void:
	host.model.global_position = pos
