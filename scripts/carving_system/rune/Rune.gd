extends Node
class_name Rune

@warning_ignore("unused_signal")
signal setup(owning_unit: Unit)
signal activation()

signal started_charging()
signal charge_shot(power: float) # from 0.0 -> 1.0 When_charge_shot

signal stop()
signal empty()

enum activation_type{semi, charge, hold}

@export_category("basics")
@export var type: activation_type
@export var cd: float = 0.3
@export var ammo: int = 1

var current: float = 0.0

@export_category("charged atack")
@export var charge_per_second: float
var charging: bool = false
var charged_value: float

@export_category("hold atack")
@export var fuel_tick: float
@export var activation_ticks: int
var holding: bool
var current_second: float
var current_fuel_tick: int

func activate(value: bool) -> void:
	if type == activation_type.semi: push_to_activate(value)
	if type == activation_type.charge:
		if value: start_charge() 
		else: stop_charge()
	if type == activation_type.hold:
		if value: start_hold()
		else: stop_hold()

func push_to_activate(value: bool) -> void:
	if not value or current > 0.0: return
	ammo -= 1
	current = cd
	activation.emit()
	if ammo <= 0:
		empty.emit()

func start_charge() -> void: 
	charging = true
	charged_value = 0.0
	started_charging.emit()

func stop_charge() -> void: 
	if not charging: return
	charging = false
	current = cd
	charge_shot.emit(charged_value)
	ammo -= 1
	if ammo <= 0:
		empty.emit()

func start_hold() -> void:
	holding = true

func stop_hold() -> void: 
	stop.emit()
	holding = false

func _process(delta: float) -> void:
	if not multiplayer.is_server(): return
	current -= delta
	if charging: charged_value = clamp(charged_value+delta*charge_per_second, 0.0, 1.0)
	if holding: 
		current_second += delta
		while current_second >= fuel_tick:
			current_second -= fuel_tick
			ammo -= 1
			current_fuel_tick += 1
			if current_fuel_tick == activation_ticks:
				current_fuel_tick = 0
				activation.emit()
			if ammo < 0: empty.emit()
			
	
