extends Node

signal carved_symbol(value: int)
signal movement_vector_change(value: Vector2)
signal interact()
signal activation(value: bool)

var owner_id: int ## Coop requirement
var hold_carving: bool = true ## Accessability feature (switch/hold)
var next_carving_state: bool = true ## for (switch) accessability feature

# Multiplayer
var is_in_carving_state: bool = false
var current_movement_vector: Vector2 = Vector2.ZERO

# Funkcja lokalna
func _process(delta: float) -> void:
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
	
	var y := Input.get_axis("downward", "upward")
	var x := Input.get_axis("left", "right")
	movement_input(Vector2(x, y))
	
# RPC for server

func activate_rune(value: bool) -> void:
	activation.emit(value)

func interact_rtc() -> void:
	interact.emit()

func carving(value: bool) -> void:
	is_in_carving_state = value

func movement_input(value: Vector2) -> void:
	movement_vector_change.emit(value)

func carving_input(value: int) -> void:
	if is_in_carving_state:
		carved_symbol.emit(value)
