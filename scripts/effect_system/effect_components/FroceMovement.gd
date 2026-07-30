extends CustomNode
class_name ForceMovement

enum movement_type{forward, backward, to_position, to_unit}

@export var distance: float
@export var type: movement_type
var unit: Unit

func force_movement() -> void:
	print("Rune Activation")
	match type:
		movement_type.forward:
			var forward: Vector3 = -host.model.visible_model.basis.z
			host.model.dash(Vector2(forward.x*distance, forward.z*distance))
			host.disable_collision()
		movement_type.to_unit:
			host.model.dash(Vector2(
				unit.model.global_position.x-host.model.global_position.x, 
				unit.model.global_position.z-host.model.global_position.z), 
				unit.model.global_position.y-host.model.global_position.y
				)
			host.disable_collision()

func set_target_unit(u: Unit) -> void:
	unit = u
