extends Node
class_name InputSystem

# Interface do zastosowania
signal carved_symbol(value: int)
signal movement_vector_change(value: Vector2)
signal interact()
signal activation(value: bool)
signal target_vector_change(value: Vector2)
signal carving_change(state: bool)
# Dodanie sygnału esc_key

var owner_id: int ## Coop requirement
var hold_carving: bool = true ## Accessability feature (switch/hold)
var next_carving_state: bool = true ## for (switch) accessability feature
var dead_zone: float = 0.05
# Targeting
var target_vector: Vector2

# Multiplayer state
var is_in_carving_state: bool = false: 
	set(value):
		carving_change.emit(value)
		is_in_carving_state = value

# Funkcja lokalna
func _process(_delta: float) -> void:
	if multiplayer.get_unique_id() != owner_id: return
	if Input.is_action_just_pressed("carving"):
		if hold_carving: carving.rpc_id(1, true)
		else: carving.rpc_id(1, next_carving_state)
	elif Input.is_action_just_released("carving"):
		if hold_carving: carving.rpc_id(1, false)
		else: next_carving_state = ! next_carving_state
	
	if Input.is_action_just_pressed("interact"): interact_rtc.rpc_id(1)
	if Input.is_action_just_pressed("activate"): activate_rune.rpc_id(1, true)
	elif Input.is_action_just_released("activate"): activate_rune.rpc_id(1, false)
	
	if Input.is_action_just_pressed("carve_up"): carving_input.rpc_id(1, 0)
	if Input.is_action_just_pressed("carve_down"): carving_input.rpc_id(1, 1)
	if Input.is_action_just_pressed("carve_left"): carving_input.rpc_id(1, 2)
	if Input.is_action_just_pressed("carve_right"): carving_input.rpc_id(1, 3)

	var y := Input.get_axis("downward", "upward")
	var x := Input.get_axis("left", "right")
	movement_input.rpc_id(1, Vector2(x, y))
	update_targeting.rpc_id(1, target_vector.normalized())


func _input(event: InputEvent) -> void:
	if multiplayer.get_unique_id() != owner_id: return
	if event is InputEventMouseMotion:
		var screen_size: Vector2 = get_viewport().get_visible_rect().size/2
		target_vector = (event.position-screen_size).normalized()
	if event is InputEventJoypadMotion: # Hard coded, becouse why not
		if event.axis == 3: # Up down
			if abs(event.axis_value) < dead_zone: target_vector.y = 0.0
			else: target_vector.y = snappedf(event.axis_value, 0.01)
		if event.axis == 2: # left right
			if abs(event.axis_value) < dead_zone: target_vector.x = 0.0
			else:target_vector.x = snappedf(event.axis_value, 0.01)

# RPC for server
@rpc("any_peer", "call_local", "unreliable")
func activate_rune(value: bool) -> void:
	activation.emit(value)

@rpc("any_peer", "call_local", "unreliable")
func interact_rtc() -> void:
	interact.emit()

@rpc("any_peer", "call_local", "reliable")
func carving(value: bool) -> void:
	is_in_carving_state = value

@rpc("any_peer", "call_local", "unreliable")
func movement_input(value: Vector2) -> void:
	movement_vector_change.emit(value)
	
@rpc("any_peer", "call_local", "unreliable")
func update_targeting(value: Vector2) -> void:
	target_vector_change.emit(value)

@rpc("any_peer", "call_local", "unreliable_ordered")
func carving_input(value: int) -> void:
	if is_in_carving_state:
		carved_symbol.emit(value)
