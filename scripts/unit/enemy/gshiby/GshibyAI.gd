extends EnemyAI
class_name GshibyAI #🐟

enum State {
	SCOUTING,
	INTERESTED,
	CHASING, 
	ATTACKING,
}
func on_stun() -> void: pass
func on_un_stun() -> void: pass

@export_category("References")
@export var movement: MovementControler
@export var nav: NavigationAgent3D
@export var sense_range: Area3D
@export var scouting_range: Area3D
@export var target_oponent: Unit = null

@export_category("Parameters")
@export var distance_to_attack: float = 5.
@export var jump_force: float = 100.0

var state := GshibyAI.State.SCOUTING :
	set = _set_state
## Unit has reached navigation target destination
var on_target: bool = true


@export_category("Timers")
@export var scouting_cooldown: float = 2.0
@export var chasing_cooldown: float = 0.33
@export var end_chasing_time: float = 1.2
var _scout_timer: float = 0.0
var _chase_timer: float = 0.0
var _end_chase_timer: float = 0.0

func _ready() -> void:
	#scout_timer.timeout.connect(find_scouting_point)
	nav.velocity_computed.connect(avoident_movemnt)
	sense_range.body_entered.connect(on_player_noticed)

#region FSM
func _set_state(new_state: State) -> void:
	_exit_state(state)
	state = new_state
	_enter_state(state)

func _enter_state(_state: State) -> void:
	print("@", Engine.get_process_frames(), " | ", self, " : ", State.keys()[_state])
	match _state:
		State.SCOUTING:
			find_scouting_point()
			_scout_timer = 0.0
		State.CHASING:
			_chase_timer = 0.0
		State.ATTACKING:
			movement.enable_gravity()
			movement.jump(jump_force)
			await get_tree().create_timer(3.0).timeout

func _exit_state(_state: State) -> void:
	match _state:
		pass

func _process_state(_state: State, delta: float) -> void:
	print(movement.velocity)
	match state:
		State.SCOUTING:
			scout(delta)
		State.CHASING:
			chase(delta)
#endregion FSM

## Finds possible points to wander to and set navigation target if found
func find_scouting_point() -> void:
	var current_point: Vector3
	var possible_targets: Array[Area3D] = scouting_range.get_overlapping_areas()
	
	if possible_targets.is_empty():
		current_point = movement.global_position + Vector3(randf(), 0, randf())*20.0
	else:
		current_point = possible_targets.pick_random().global_position
	
	nav.target_position = current_point + Vector3(randf(), 0, randf())*2.0
	if not nav.is_target_reachable():
		nav.target_position = current_point	
	
	on_target = false

func _physics_process(_delta: float) -> void:
	_process_state(state, _delta)
	do_nav_movement()

func do_nav_movement() -> void:
	## TODO Nie kalkuluje sie predkosc Y ??
	var dir: Vector3 = movement.global_position.direction_to( \
			nav.get_next_path_position()) * Vector3(1, 0, 1) \
			+ movement.velocity.y * Vector3.UP
	nav.velocity = dir * movement.walking_speed
	
	var grounded_vel := movement.velocity*Vector3(1,0,1)
	if not is_zero_approx(grounded_vel.length_squared()):
		movement.visible_model.look_at( \
			(movement.global_position - grounded_vel))

func scout(delta: float) -> void:
	
	_scout_timer -= delta
	
	if nav.is_navigation_finished():
		if not on_target:
			_scout_timer = scouting_cooldown
		on_target = true
	
	if on_target and _scout_timer <= 0.:
		find_scouting_point()

func chase(delta: float) -> void:
	_chase_timer -= delta
	# Update every 0.3 s
	if nav.distance_to_target() < distance_to_attack:
		state = State.ATTACKING
		return
	
	if _chase_timer <= 0.0:
		#on_target = false
		nav.target_position = target_oponent.model.global_position
		## Target reachable -> reset end chase timer
		if target_oponent.model in sense_range.get_overlapping_bodies() and nav.is_target_reachable():
			_end_chase_timer = end_chasing_time
		elif _end_chase_timer <= 0.0:
			state = State.SCOUTING
			return
		
		_chase_timer = chasing_cooldown

func atack() -> void:
	pass

func avoident_movemnt(safe_velocity: Vector3) -> void:
	if movement.current_state == MovementControler.states.normal:
		movement.velocity = safe_velocity

func on_player_noticed(collider: Node3D) -> void:
	if collider is MovementControler and collider.type == MovementControler.pupet_type.player:
		target_oponent = collider.owner
		state = State.CHASING
