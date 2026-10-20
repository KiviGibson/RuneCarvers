extends CustomNode
class_name ForceMovement

enum movement_type{forward, to_unit, using_displacement_vector, to_movement_vector}

@export var distance: float
@export var type: movement_type
@export var displacement_vector: Vector3
var unit: Unit
@export var local_host: Unit
@export var use_local_host: bool = false

func _ready() -> void:
	if use_local_host: host = local_host

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
		movement_type.using_displacement_vector:
			host.model.dash(Vector2(displacement_vector.x*distance, displacement_vector.z*distance))
		movement_type.to_movement_vector:
			var forward: Vector3 = (host.model.velocity*Vector3(1,0,1)).normalized()
			if host.model.velocity*Vector3(1,0,1) == Vector3.ZERO:
				forward = -host.model.visible_model.basis.z
			host.model.dash(Vector2(forward.x*distance, forward.z*distance))
			host.disable_collision()
func set_target_unit(u: Unit) -> void:
	unit = u
