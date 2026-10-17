extends Area3D
class_name InteractSystem
## Connects player input with objects that are interactable in range
signal carving_zone_entered()
signal carving_zone_exit()

var owner_id: int
@export var input: InputSystem
@export var interact_ui: Node3D

var npcs_in_range : Array

func _ready() -> void:
	if not multiplayer.is_server(): return
	area_entered.connect(on_interactable_enter)
	area_exited.connect(on_interactable_exit)

func on_interactable_enter(interaction_zone: Area3D) -> void:
	if (body_entered.get_object().has_method("start_dialogue")): # save npcs to array
		npcs_in_range.append(body_entered.get_object())
		
	if not multiplayer.is_server() or interaction_zone is not Interactable: return
	if not interaction_zone.can_connect(): return
	interaction_zone.connect_unit(owner_id)
	if interaction_zone is CarvingInterationZone:
		on_carving_zone_enter(interaction_zone)
		return
	input.interact.connect(interaction_zone.interaction_call)

func on_interactable_exit(interaction_zone: Area3D) -> void:
	if (body_entered.get_object().has_method("start_dialogue")): # delete npcs from array
		npcs_in_range.erase(body_entered.get_object())

	if not multiplayer.is_server() or interaction_zone is not Interactable: return
	interaction_zone.disconnect_unit(owner_id)
	if interaction_zone is CarvingInterationZone:
		on_carving_zone_exit(interaction_zone)
		return
	input.interact.disconnect(interaction_zone.interaction_call)

func on_carving_zone_enter(interaction_zone: CarvingInterationZone) -> void:
	input.carving_change.connect(interaction_zone.carving_change)
	input.carved_symbol.connect(interaction_zone.symbol_carved)
	carving_zone_entered.emit()

func on_carving_zone_exit(interaction_zone: CarvingInterationZone) -> void:
	input.carving_change.disconnect(interaction_zone.carving_change)
	input.carved_symbol.disconnect(interaction_zone.symbol_carved)
	carving_zone_exit.emit()

func _process(_float):
	if Input.is_action_pressed("interact"): # interact nearest npc
		var nearest_npc = _get_nearest_npc()
		nearest_npc.start_dialogue()
		print("interact")

func _get_nearest_npc() -> Node:
	var nearest: Node = null
	var nearest_dist_sq := INF
	for npc in npcs_in_range:
		if not is_instance_valid(npc):
			continue
		var dist_sq := global_position.distance_squared_to(npc.global_position)
		if dist_sq < nearest_dist_sq:
			nearest_dist_sq = dist_sq
			nearest = npc
	return nearest
	
