extends CharacterBody3D
class_name MovementControler

enum pupet_type{player, enemy}
enum states{normal, running, focus, force, stun}

signal finish_force_movement()

var in_combat: bool = false

var walking_speed: float = 5
var running_mult: float = 1.5
var focus_mult: float = 0.5
var force_mult: float = 9
@export var visible_model: Node3D
@export var type: pupet_type = pupet_type.enemy

var player_added_velocity: Vector3
var current_state: states = states.normal
var distance: float = 0.0
var stamina: float = 5.0
var current_stamina: float = 0.0
var exhausted: bool = false
@export var gravity: float = 9.81

func disable_gravity() -> void: gravity = 0.0
func enable_gravity() -> void: gravity = 9.81

func _ready() -> void:
	finish_force_movement.connect(enable_gravity)

func setup_movement(ms: float, rm:float, fm: float, st: float) -> void:
	walking_speed = ms
	running_mult = rm
	focus_mult = fm
	stamina = st
	current_stamina = st

func set_movement_vector(value: Vector2) -> void:
	player_added_velocity = Vector3(value.x, 0, -value.y)

func set_rotation_vector(value: Vector2) -> void:
	if value == Vector2.ZERO: return
	if current_state == states.force: return
	visible_model.basis.z = Vector3(-value.x, 0, -value.y)
	visible_model.basis.x = Vector3(-value.y, 0, value.x)

func _physics_process(delta: float) -> void: ## Add gravity
	if not multiplayer.is_server(): return
	velocity.y -= gravity*delta
	match current_state:
		states.stun:
			velocity = velocity * Vector3(0, 1, 0)
			return
		states.force:
			force_state(delta)
			return
		_:
			velocity = player_added_velocity * walking_speed + velocity * Vector3(0, 1, 0)
	match current_state:
		states.running: running_state(delta)
		states.focus: focus_state(delta)
		states.normal: normal_state(delta)
	move_and_slide()

func running_state(delta: float) -> void:
	velocity *= running_mult
	if velocity.x + velocity.z <= 0.3:
		current_state = states.normal
	if in_combat:
		current_stamina -= delta
		if current_stamina <= 0.0:
			current_state = states.normal
			exhausted = true

func normal_state(delta: float) -> void:
	if current_stamina < stamina:
		current_stamina += delta
		if exhausted and current_stamina >= stamina:
			current_stamina = stamina
			exhausted = false

func focus_state(delta: float) -> void:
	velocity *= focus_mult

func force_state(delta: float) -> void:
	distance -= delta*force_mult*walking_speed
	if distance <= 0:
		current_state = states.normal
		finish_force_movement.emit()
	move_and_slide()

func dash(vec: Vector2, y: float = 0) -> void:
	velocity = Vector3(vec.x, y, vec.y).normalized()*walking_speed*force_mult
	set_rotation_vector(vec.normalized())
	distance = sqrt(vec.x**2 + vec.y**2 + y**2)
	current_state = states.force
	disable_gravity()

func jump(vel: float) -> void:
	velocity = velocity* Vector3(1, 0, 1) + vel* Vector3(0, 1, 0)
	enable_gravity()

func change_state() -> void:
	current_state = states.running
