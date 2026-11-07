extends MovementControler
class_name PlayerMovement

@export var running_mult: float = 1.5
@export var focus_mult: float = 0.5

var stamina: float = 5.0
var current_stamina: float = 0.0
var exhausted: bool = false
var in_combat: bool = false
var player_added_velocity: Vector3


func dash(vec: Vector2, y: float = 0) -> void:
	velocity = Vector3(vec.x, y, vec.y).normalized()*walking_speed*force_mult
	set_rotation_vector(vec.normalized())
	distance = sqrt(vec.x**2 + vec.y**2 + y**2)
	current_state = states.force
	disable_gravity()

func jump(vel: float, force: bool = false) -> void:
	if not force and not self.is_on_floor(): return
	velocity = velocity* Vector3(1, 0, 1) + vel* Vector3(0, 1, 0)
	enable_gravity()

func set_movement_vector(value: Vector2) -> void:
	player_added_velocity = Vector3(value.x, 0, -value.y)

func set_rotation_vector(value: Vector2) -> void:
	if value == Vector2.ZERO: return
	if current_state in [states.force, states.stun]: return
	visible_model.basis.z = Vector3(-value.x, 0, -value.y)
	visible_model.basis.x = Vector3(-value.y, 0, value.x)

func run() -> void:
	if current_state == states.normal and not exhausted:
		current_state = states.running
	elif current_state == states.running:
		current_state = states.normal

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
	velocity *= running_mult * Vector3(1, 0, 1) + Vector3(0, 1, 0)
	if abs(velocity)*Vector3(1,0,1) > Vector3.ZERO:
		current_stamina = clampf(current_stamina-delta, 0, stamina)
	else:
		gather_stamina(delta)
	if current_stamina <= 0.0:
		current_state = states.normal
		exhausted = true

func external_state(_delta: float) -> void:
	move_and_slide()

func normal_state(delta: float) -> void:
	gather_stamina(delta)

func focus_state(delta: float) -> void:
	velocity *= focus_mult*Vector3(1, 0, 1) + Vector3(0,1,0)
	gather_stamina(delta)

func gather_stamina(delta: float) -> void:
	if current_stamina < stamina:
		current_stamina = clampf(current_stamina+2*delta, 0, stamina)
		if exhausted and current_stamina >= stamina:
			current_stamina = stamina
			exhausted = false
