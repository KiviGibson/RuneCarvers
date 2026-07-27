extends Unit
class_name Player

@export var input_system: InputSystem
@export var carving_system: CarvingSystem
@export var carving_ui: Control ## Reparents to game overlay node
@export var camera: Camera3D
@export var interact_system: InteractSystem
@export var hp_bar: HpBar
var owner_id: int: 
	set(value):
		owner_id = value
		interact_system.owner_id = owner_id
var current_rune: Rune

func _ready() -> void:
	enable_camera()
	super._ready()

func enable_camera() -> void:
	if owner_id != multiplayer.get_unique_id():
		model.remove_child(camera)
		camera.free()

func _on_health_change(curernt: int, absolute: int) -> void:
	if not multiplayer.is_server(): return
	hp_bar.health_change.rpc(curernt, absolute)

func _on_health_depleated() -> void: pass # Death func

func remove_rune() -> void: ## Usuń starą runę
	if not multiplayer.is_server(): return
	current_rune.queue_free()
	current_rune.empty.disconnect(remove_rune)
	current_rune = null

func get_rune(rune: PackedScene) -> void: ## Ustaw nową runę
	if current_rune: remove_rune()
	var tmp : Rune = rune.instantiate()
	add_child(tmp)
	tmp.setup.emit(self)
	tmp.empty.connect(remove_rune)
	current_rune = tmp

func use_rune(value: bool) -> void: ## Użyj runy
	if current_rune:
		current_rune.activate(value)
