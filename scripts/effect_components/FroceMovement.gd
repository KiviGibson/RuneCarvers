extends Node
class_name Dash

enum movement_type{forward, backward, to_position}

@export var distance: float
@export var type: movement_type

var host: Unit

func setup(h: Unit) -> void:
	host = h

func force_movement() -> void:
	print("Rune Activation")
	match type:
		movement_type.forward:
			var forward: Vector3 = -host.model.visible_model.basis.z
			host.model.dash(Vector2(forward.x*distance, forward.z*distance))
			host.disable_collision()
