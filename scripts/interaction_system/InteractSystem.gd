extends Area3D
class_name InteractSystem
## Connects player input with objects that are interactable in range
signal carving_zone_entered()
signal carving_zone_exit()

var owner_id: int
@export var input: InputSystem
@export var interact_ui: Node3D

func _ready() -> void:
	if not multiplayer.is_server(): return
	area_entered.connect(on_interactable_enter)
	area_exited.connect(on_interactable_exit)

func on_interactable_enter(interaction_zone: Area3D) -> void:
	if not multiplayer.is_server() or interaction_zone is not Interactable: return
	if not interaction_zone.can_connect(): return
	interaction_zone.connect_unit(owner_id)
	if interaction_zone is CarvingInterationZone:
		on_carving_zone_enter(interaction_zone)
		return
	input.interact.connect(interaction_zone.interaction_call)

func on_interactable_exit(interaction_zone: Area3D) -> void:
	if not multiplayer.is_server() or interaction_zone is not Interactable: return
	interaction_zone.disconnect_unit(owner_id)
	if interaction_zone is CarvingInterationZone:
		on_carving_zone_exit(interaction_zone)
		return
	input.interact.disconnect(interaction_zone.interaction_call)

func on_carving_zone_enter(interaction_zone: CarvingInterationZone) -> void:
	input.carving_change.connect(interaction_zone.carving_change)
	input.carved_symbol.connect(interaction_zone.symbol_carved)
	print("Connected")
	carving_zone_entered.emit()

func on_carving_zone_exit(interaction_zone: CarvingInterationZone) -> void:
	input.carving_change.disconnect(interaction_zone.carving_change)
	input.carved_symbol.disconnect(interaction_zone.symbol_carved)
	print("Disconnect")
	carving_zone_exit.emit()
