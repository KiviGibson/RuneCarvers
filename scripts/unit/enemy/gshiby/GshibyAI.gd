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

@export var movement: MovementControler
@export var nav: NavigationAgent3D
@export var sense_range: Area3D
@export var scouting_range: Area3D
@export var target_oponent: Unit = null
@export var scout_timer: Timer
@export var chase_timer: Timer
@export var hitbox_collision: CollisionShape3D
@export_category("jump attack")
@export var attack_distance: float = 15.0
@export var initial_jump_velocity: float = 10.0
@export var jump_height: float = 300.0
var state := GshibyAI.State.SCOUTING
## Unit has reached navigation target destination
var on_target: bool = true

func _ready() -> void:
	scout_timer.timeout.connect(find_scouting_point)
	nav.velocity_computed.connect(avoident_movemnt)
	sense_range.body_entered.connect(on_player_noticed)

func find_scouting_point() -> void:
	if state != State.SCOUTING: return 
	
	var current_point: Area3D = scouting_range.get_overlapping_areas().pick_random()
	if current_point == null: return
	
	nav.target_position = current_point.global_position + Vector3(randf(), 0, randf())*2.0
	on_target = false


func _physics_process(_delta: float) -> void:
	if on_target: return
	
	var dir: Vector3 = movement.global_position.direction_to( \
			nav.get_next_path_position()) * Vector3(1, 0, 1)
	nav.velocity = dir * movement.walking_speed
	var grounded_vel := movement.velocity*Vector3(1,0,1)
	if not grounded_vel.is_zero_approx():
		movement.visible_model.look_at( \
			(movement.visible_model.global_position - grounded_vel))
	#assert(movement.velocity.is_finite(), "inf vel @ %s" %self)

func _process(_delta: float) -> void:
	match state:
		State.SCOUTING: scout()
		State.CHASING: chase()
		State.ATTACKING: attack()
	print("gshib state : ", State.keys()[state])

func scout() -> void:
	if nav.is_navigation_finished():
		on_target = true
		if scout_timer.is_stopped(): scout_timer.start()

func chase() -> void: 
	# Update every 0.3 s
	if chase_timer.is_stopped():
		on_target = false
		if target_oponent.model in sense_range.get_overlapping_bodies() and nav.is_target_reachable():
			nav.target_position = target_oponent.model.global_position
			scout_timer.start(1.2)
		elif scout_timer.is_stopped():
			state = State.SCOUTING
		else: nav.target_position = movement.global_position
		chase_timer.start()
		
		if nav.distance_to_target() <= attack_distance:
			start_attack()

func attack() -> void:
	if movement.is_on_floor():
		
		state = State.SCOUTING
		hitbox_collision.disabled = true

func start_attack() -> void:
	movement.enable_gravity()
	var dir := nav.target_position - movement.global_position
	movement.velocity.x = (dir * initial_jump_velocity).x
	movement.velocity.z = (dir * initial_jump_velocity).z
	movement.jump(jump_height, true)
	nav.velocity = movement.velocity
	
	state = State.ATTACKING
	hitbox_collision.disabled = false

func avoident_movemnt(safe_velocity: Vector3) -> void:
	if movement.current_state == MovementControler.states.normal:
		movement.velocity = safe_velocity

func on_player_noticed(collider: CharacterBody3D) -> void:
	if collider is MovementControler and collider.type == MovementControler.pupet_type.player:
		target_oponent = collider.owner
		state = State.CHASING
