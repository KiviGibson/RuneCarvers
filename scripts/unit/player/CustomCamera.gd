extends Camera3D
class_name CustomCamera

@export var target: Node3D
var default_rotation: Vector3
var base_offset: Vector3

func _ready() -> void:
	default_rotation = rotation
	base_offset = global_position

func _process(delta: float) -> void:
	if target: global_position = target.global_position+base_offset
