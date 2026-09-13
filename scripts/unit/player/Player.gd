extends Unit
class_name Player
enum player_states{normal, locked, running, carving}
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
var owner_id: int: 
	set(value):
		owner_id = value
		interact_system.owner_id = owner_id

var current_rune: Rune
func _ready() -> void:
	super._ready()
	inventory.host = self

func _on_health_change(curernt: int, absolute: int) -> void:
	if not multiplayer.is_server(): return
	hp_bar.health_change.rpc(curernt, absolute)
	start_combat()

func _on_health_depleated() -> void: pass # Death func

func remove_rune() -> void: ## Usuń starą runę
	if not multiplayer.is_server(): return
	current_rune.queue_free()
	current_rune.empty.disconnect(remove_rune)
	current_rune = null

func get_rune(rune: PackedScene) -> void: ## Ustaw nową runę
	if current_rune: remove_rune()
	var tmp: Rune = rune_spawner.spawn({"rune": rune.get_instance_id()})
	current_rune = tmp

func use_rune(value: bool) -> void: ## Użyj runy
	if current_rune:
		current_rune.activate(value)
		start_combat()

func _process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	if current_rune:
		counter_indicator.text = str(current_rune.ammo)
	else:
		counter_indicator.text = "0"
	stamina_bar.value = float(model.current_stamina)/float(model.stamina)

func start_combat() -> void:
	model.in_combat = true
	combat_timer.start()

func leave_combat() -> void:
	model.in_combat = false
