extends CharacterBody3D
class_name MovementControler
const walking_speed: float = 5
var player_added_velocity: Vector3
@export var visible_model: Node3D

func set_movement_vector(value: Vector2) -> void:
	player_added_velocity = Vector3(value.x, 0, -value.y)

func set_rotation_vector(value: Vector2) -> void:
	if value == Vector2.ZERO: return
	visible_model.basis.z = Vector3(-value.x, 0, -value.y)
	visible_model.basis.x = Vector3(-value.y, 0, value.x)
	
func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	velocity = player_added_velocity* walking_speed
	move_and_slide()
