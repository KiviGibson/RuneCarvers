extends EnemyAI
class_name GshibyAI

enum grzib_state{scouting, intrested, chaseing, atacking}
func on_stun() -> void: pass
func on_un_stun() -> void: pass

@export var movement: MovementControler
@export var nav: NavigationAgent3D
@export var sense_range: Area3D
@export var scouting_range: Area3D
@export var target_oponent: Unit = null
@export var scout_timer: Timer
@export var chase_timer: Timer
var state: grzib_state = grzib_state.scouting
var on_target: bool = true

func _ready() -> void:
	scout_timer.timeout.connect(find_scouting_point)
	nav.velocity_computed.connect(avoident_movemnt)
	sense_range.body_entered.connect(on_player_noticed)

func find_scouting_point() -> void:
	if state != grzib_state.scouting: return 
	var current_point: Area3D = scouting_range.get_overlapping_areas().pick_random()
	if current_point == null: return
	nav.target_position = current_point.global_position + Vector3(randf(), 0, randf())*2.0
	on_target = false


func _physics_process(_delta: float) -> void:
	if on_target: return
	var t: Vector3 = movement.global_position.direction_to(nav.get_next_path_position())*Vector3(1, 0, 1)
	nav.velocity = t * movement.walking_speed
	movement.visible_model.look_at(movement.velocity*Vector3(1,0,1) + movement.visible_model.global_position*Vector3(0,1,0))

func _process(_delta: float) -> void:
	match state:
		grzib_state.scouting: scout()
		grzib_state.chaseing: chase()

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
			state = grzib_state.scouting
		else: nav.target_position = movement.global_position
		chase_timer.start()
func atack() -> void: pass

func avoident_movemnt(safe_velocity: Vector3) -> void:
	if movement.current_state == MovementControler.states.normal:
		movement.velocity = safe_velocity

func on_player_noticed(collider: CharacterBody3D) -> void:
	if collider is MovementControler and collider.type == MovementControler.pupet_type.player:
		target_oponent = collider.owner
		state = grzib_state.chaseing
