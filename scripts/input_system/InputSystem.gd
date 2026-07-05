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
var dead_zone: float = 0.04
# Targeting
var target_vector: Vector2

# Multiplayer state
var is_in_carving_state: bool = false: 
	set(value):
		carving_change.emit(value)
		is_in_carving_state = value

# Funkcja lokalna
func _process(_delta: float) -> void:
	# Check for correct user
	if Input.is_action_just_pressed("carving"):
		if hold_carving: carving(true)
		else: carving(next_carving_state)
	elif Input.is_action_just_released("carving"):
		if hold_carving: carving(false)
		else: next_carving_state = ! next_carving_state
	
	if Input.is_action_just_pressed("interact"): interact_rtc()
	if Input.is_action_just_pressed("activate"): activate_rune(true)
	elif Input.is_action_just_released("activate"): activate_rune(false)
	
	if Input.is_action_just_pressed("carve_up"): carving_input(0)
	if Input.is_action_just_pressed("carve_down"): carving_input(1)
	if Input.is_action_just_pressed("carve_left"): carving_input(2)
	if Input.is_action_just_pressed("carve_right"): carving_input(3)

	var y := Input.get_axis("downward", "upward")
	var x := Input.get_axis("left", "right")
	movement_input(Vector2(x, y))
	update_targeting(target_vector)


func _input(event: InputEvent) -> void:
	# Sprawdź ownera
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
func activate_rune(value: bool) -> void:
	activation.emit(value)

func interact_rtc() -> void:
	interact.emit()

func carving(value: bool) -> void:
	is_in_carving_state = value

func movement_input(value: Vector2) -> void:
	movement_vector_change.emit(value)

func update_targeting(value: Vector2) -> void:
	target_vector_change.emit(target_vector)

func carving_input(value: int) -> void:
	if is_in_carving_state:
		carved_symbol.emit(value)
