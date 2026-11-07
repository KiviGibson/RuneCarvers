extends Area3D
class_name Collector

signal collected()

func _ready() -> void:
	body_entered.connect(collector)

func setup(unit: Unit) -> void:
	global_position = unit.model.global_position

func collector(collider: Node3D) -> void:
	collected.emit()
	collider.queue_free()
