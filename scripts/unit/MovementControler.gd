extends CharacterBody3D
class_name MovementControler

enum pupet_type{player, enemy}
enum states{normal, running, focus, force, stun, dash}

signal finish_force_movement()

@export var walking_speed: float = 5
@export var force_mult: float = 9
@export var visible_model: Node3D
@export var type: pupet_type = pupet_type.enemy


var current_state: states = states.normal
var distance: float = 0.0

@export var gravity: float = 9.81

func disable_gravity() -> void: gravity = 0.0
func enable_gravity() -> void: gravity = 9.81

func _ready() -> void:
	finish_force_movement.connect(enable_gravity)

func force_state(delta: float) -> void:
	distance -= delta*force_mult*walking_speed
	print("Forced")
	if distance <= 0:
		current_state = states.normal
		velocity = Vector3.ZERO
		finish_force_movement.emit()
	move_and_slide()

func _physics_process(delta: float) -> void:
	if current_state == states.normal: move_and_slide()
	if current_state == states.force: force_state(delta)
	if current_state == states.stun: 
		velocity *= Vector3(0, 1, 0)
		move_and_slide()

func dash(vec: Vector2, y: float = 0) -> void:
	velocity = Vector3(vec.x, y, vec.y).normalized()*walking_speed*force_mult
	distance = sqrt(vec.x**2 + vec.y**2 + y**2)
	current_state = states.force
	disable_gravity()
