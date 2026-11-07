extends Unit
class_name Player

const recovery_code: Array[int] = [1,2,0,3,1]

@export var input_system: InputSystem
@export var carving_system: CarvingSystem
@export var carving_ui: Control ## Reparents to game overlay node
@export var camera: Camera3D
@export var interact_system: InteractSystem
@export var hp_bar: HpBar
@export var view: SubViewport
@export var inventory: Inventory
@export var rune_spawner: RuneSpawner
@export var counter_indicator: Label
@export var stamina_bar: ProgressBar
@export var combat_timer: Timer

@export var recovery_zone: CarvingInterationZone
@export var code_handler: CodeHandler
var recovery_state: bool = false
var current_recovery_code: int = 0

var owner_id: int: 
	set(value):
		owner_id = value
		interact_system.owner_id = owner_id

var current_rune: Rune
func _ready() -> void:
	super._ready()
	inventory.host = self
	code_handler.setup()

func _on_health_change(curernt: int, absolute: int) -> void:
	if not multiplayer.is_server(): return
	hp_bar.health_change.rpc(curernt, absolute)
	start_combat()

func _on_health_depleated() -> void:
	recovery_zone.collision_layer = 16 # Interaction zone collision layer
	recovery_zone.collision_mask = 16
	recovery_zone.visible = true
	stun()
	remove_rune()
	leave_combat()

func remove_rune() -> void: ## Usuń starą runę
	if not multiplayer.is_server() or not current_rune: return
	current_rune.queue_free()
	current_rune.empty.disconnect(remove_rune)
	current_rune = null

func get_rune(rune: PackedScene) -> void: ## Ustaw nową runę
	if current_rune: remove_rune()
	var tmp: Rune = rune_spawner.spawn({"rune": rune.get_instance_id()})
	current_rune = tmp

func use_rune(value: bool) -> void: ## Użyj runy
	if current_rune and not recovery_state:
		current_rune.activate(value)
		start_combat()

func _process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	if current_rune:
		counter_indicator.text = str(current_rune.ammo)
	else:
		counter_indicator.text = "0"
	if model is PlayerMovement:
		stamina_bar.value = float(model.current_stamina)/float(model.stamina)

func start_combat() -> void:
	model.in_combat = true
	combat_timer.start()

func leave_combat() -> void:
	model.in_combat = false

func stun() -> void:
	model.current_state = model.states.stun
	carving_system.stop_carving()
	carving_system.switch_carving(true)

func un_stun() -> void:
	if recovery_state: return
	model.current_state = model.states.normal
	carving_system.switch_carving(false)
	print("Unstun")

func recovery_sign(signum: int) -> void:
	if recovery_code[current_recovery_code] == signum:
		current_recovery_code += 1
		code_handler.add_sign(signum)
		if current_recovery_code == len(recovery_code):
			recovery_zone.collision_layer = 0
			recovery_zone.collision_mask = 0
			recovery_zone.visible = false
			recovery_state = false
			un_stun()
			stats.current_health = snappedi(stats.max_health*0.3, 1)
	else: 
		current_recovery_code = 0
		code_handler.reset()

func reset_recovery() -> void:
	current_recovery_code = 0
	code_handler.reset()
