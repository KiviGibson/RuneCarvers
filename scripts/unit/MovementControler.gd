extends CharacterBody3D
class_name MovementControler

enum states{normal, running, focus, force}
signal finish_force_movement()
const walking_speed: float = 5
const running_mult: float = 1.5
const focus_mult: float = 0.5
const force_mult: float = 8

var player_added_velocity: Vector3
@export var visible_model: Node3D
var current_state: states = states.normal
var distance: float = 0.0

func set_movement_vector(value: Vector2) -> void:
	player_added_velocity = Vector3(value.x, 0, -value.y)

func set_rotation_vector(value: Vector2) -> void:
	if value == Vector2.ZERO: return
	if current_state == states.force: return
	visible_model.basis.z = Vector3(-value.x, 0, -value.y)
	visible_model.basis.x = Vector3(-value.y, 0, value.x)

func _physics_process(delta: float) -> void: ## Add gravity
	if not multiplayer.is_server(): return
	if current_state == states.force:
		forced_movement(delta)
		return
	velocity = player_added_velocity* walking_speed
	match current_state:
		states.running: velocity *= running_mult
		states.focus: velocity *= focus_mult
	move_and_slide()

func forced_movement(delta: float) -> void:
	distance -= delta*force_mult*walking_speed
	if distance <= 0:
		current_state = states.normal
		finish_force_movement.emit()
	move_and_slide()

func dash(vec: Vector2) -> void:
	velocity = Vector3(vec.x, 0, vec.y).normalized()*walking_speed*force_mult
	set_rotation_vector(vec.normalized())
	distance = sqrt(vec.x**2 + vec.y**2)
	current_state = states.force
