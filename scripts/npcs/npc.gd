extends CharacterBody3D

var label : Label3D
var brain : Node 
var detector : Area3D
var model : Node3D

var players_in_range : Array[Player] = []

# move rolling
var wander_timer : Timer
var target_position : Vector3
var is_walking : bool = false
var spawn_position : Vector3

@export var player_see_range : float
@export var npc_data : NPCData

func _ready() -> void:
	label = $"Label"
	brain = $"Brain"
	detector = $"Detector"
	model = $"Model"
	
	if npc_data and npc_data.visual_model:
		model.add_child(npc_data.visual_model.instantiate())

	var collision_shape = detector.get_node_or_null("CollisionShape3D")
	if collision_shape and collision_shape.shape is CylinderShape3D:
		collision_shape.shape.radius = player_see_range

	if label:
		label.text = ""

	detector.body_entered.connect(_on_detector_body_entered)
	detector.body_exited.connect(_on_detector_body_exited)
	_setup_wander_timer()

func _physics_process(delta: float) -> void:
	if is_walking and npc_data:
		var dir = (target_position - global_position)
		dir.y = 0
		
		if dir.length() < 0.2:
			velocity = Vector3.ZERO
			is_walking = false
			_start_random_timer()
		else:
			dir = dir.normalized()
			velocity = dir * npc_data.move_speed
			var target_look = global_position + dir
			if global_position.distance_to(target_look) > 0.01:
				look_at(target_look, Vector3.UP)
	else:
		if not is_on_floor():
			velocity.y -= 9.8 * delta
		else:
			velocity.x = 0
			velocity.z = 0
	move_and_slide()

func _setup_wander_timer() -> void:
	wander_timer = Timer.new()
	wander_timer.one_shot = true
	wander_timer.timeout.connect(_on_wander_timer_timeout)
	add_child(wander_timer)
	
	_start_random_timer()

func _start_random_timer() -> void:
	if npc_data and wander_timer:
		var random_idle_time = randf_range(npc_data.idle_time_min, npc_data.idle_time_max)
		wander_timer.start(random_idle_time)

func _on_wander_timer_timeout() -> void:
	if npc_data:
		var random_angle = randf() * TAU
		var random_distance = randf() * npc_data.wander_radius
		
		var offset = Vector3(cos(random_angle), 0, sin(random_angle)) * random_distance
		target_position = spawn_position + offset
		
		is_walking = true
		
func _on_detector_body_entered(body: Node3D) -> void:
	var player := body.get_parent() as Player  
	if player == null:
		return
	if not players_in_range.has(player):
		players_in_range.append(player)
	_update_label()

func _on_detector_body_exited(body: Node3D) -> void:
	var player := body.get_parent() as Player
	if player == null:
		return
	players_in_range.erase(player)
	_update_label()

func _update_label() -> void:
	var local_near := players_in_range.any(
		func(p: Player) -> bool: return p.owner_id == multiplayer.get_unique_id())
	label.text = npc_data.display_name if local_near and npc_data else ""
