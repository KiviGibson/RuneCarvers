extends CharacterBody3D

@export var player_see_range : float = 10.0   ## pokazuje label nad NPC
@export var interact_range : float = 3.0      ## dystans, z którego można interact (F)
@export var npc_data : NPCData

const SMOOTHING := 15.0  

var label : Label3D
var detector : Area3D
var model : Node3D
var players_in_range : Array[Player] = []

var wander_timer : Timer
var target_position : Vector3
var is_walking : bool = false
var spawn_position : Vector3

var sync_position : Vector3
var sync_yaw : float

func _ready() -> void:
	add_to_group("npc")
	label = $"Label"
	detector = $"Detector"
	model = $"Model"

	spawn_position = global_position
	sync_position = position  
	sync_yaw = rotation.y

	if npc_data and npc_data.visual_model:
		model.add_child(npc_data.visual_model.instantiate())

	detector.collision_layer = 0
	detector.collision_mask = 2 
	var shape_node := detector.get_node_or_null("CollisionShape3D") as CollisionShape3D
	if shape_node and shape_node.shape and "radius" in shape_node.shape:
		shape_node.shape = shape_node.shape.duplicate()
		shape_node.shape.radius = player_see_range

	label.text = ""
	detector.body_entered.connect(_on_detector_body_entered)
	detector.body_exited.connect(_on_detector_body_exited)

	_setup_synchronizer()

	var is_server := multiplayer.is_server()
	set_physics_process(is_server)
	set_process(not is_server) 
	if is_server:
		_setup_wander_timer()

# ---------- sync ----------

func _setup_synchronizer() -> void:
	var config := SceneReplicationConfig.new()
	for prop in ["sync_position", "sync_yaw"]:
		var path := NodePath(".:" + prop)
		config.add_property(path)
		config.property_set_replication_mode(path, SceneReplicationConfig.REPLICATION_MODE_ALWAYS)
	var synchronizer := MultiplayerSynchronizer.new()
	synchronizer.name = "Synchronizer" 
	synchronizer.replication_config = config
	add_child(synchronizer)          

func _process(delta: float) -> void:  
	var t := 1.0 - exp(-SMOOTHING * delta)
	position = position.lerp(sync_position, t)
	rotation.y = lerp_angle(rotation.y, sync_yaw, t)

# ---------- wykrywanie graczy ----------

func _on_detector_body_entered(body: Node3D) -> void:
	var player := body.get_parent() as Player 
	if player == null: return
	if not players_in_range.has(player):
		players_in_range.append(player)
	_update_label()

func _on_detector_body_exited(body: Node3D) -> void:
	var player := body.get_parent() as Player
	if player == null: return
	players_in_range.erase(player)
	_update_label()

func _local_player() -> Player:
	var id := multiplayer.get_unique_id()
	for p in players_in_range:
		if is_instance_valid(p) and p.owner_id == id:
			return p
	return null

func _update_label() -> void:
	label.text = npc_data.display_name if (_local_player() != null and npc_data) else ""

# ---------- interakcja / dialog ----------

func distance_to_local_player() -> float:
	var p := _local_player()
	if p == null or p.model == null: return INF
	return global_position.distance_to(p.model.global_position)

func _is_nearest_for_local_player() -> bool:
	var mine := distance_to_local_player()
	if mine > interact_range: return false
	for other in get_tree().get_nodes_in_group("npc"):
		if other != self and other.distance_to_local_player() < mine:
			return false
	return true

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"): return
	if DialogueManager.is_active(): return
	if npc_data == null or npc_data.dialogue_path == "": return
	if not _is_nearest_for_local_player(): return
	get_viewport().set_input_as_handled()
	DialogueManager.start_dialogue(npc_data.dialogue_path)

# ---------- walk ----------
func _physics_process(delta: float) -> void:
	if is_walking and npc_data:
		var dir := target_position - global_position
		dir.y = 0
		if dir.length() < 0.2:
			velocity = Vector3.ZERO
			is_walking = false
			_start_random_timer()
		else:
			dir = dir.normalized()
			velocity = dir * npc_data.move_speed
			look_at(global_position + dir, Vector3.UP)
	else:
		if not is_on_floor():
			velocity.y -= 9.8 * delta
		else:
			velocity.x = 0
			velocity.z = 0
	move_and_slide()

	sync_position = position
	sync_yaw = rotation.y

func _setup_wander_timer() -> void:
	wander_timer = Timer.new()
	wander_timer.one_shot = true
	wander_timer.timeout.connect(_on_wander_timer_timeout)
	add_child(wander_timer)
	_start_random_timer()

func _start_random_timer() -> void:
	if npc_data and wander_timer:
		wander_timer.start(randf_range(npc_data.idle_time_min, npc_data.idle_time_max))

func _on_wander_timer_timeout() -> void:
	if npc_data:
		var angle := randf() * TAU
		var dist := randf() * npc_data.wander_radius
		target_position = spawn_position + Vector3(cos(angle), 0, sin(angle)) * dist
		is_walking = true
