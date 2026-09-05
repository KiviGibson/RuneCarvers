extends CustomNode
class_name Inventory

@export var main_gem: Gem # on -1
@export var sub_gems: Array[Gem] = [null, null, null]# from 0 to 2
@export var avilable_gems: Array[Gem] # list of avilebility
@export var gem_slots: Array[GemOption]
@export var search_menu: SearchMenu
@export var inventory_ui: EscapableUI
var currently_swapped: int = -1

func _ready() -> void:
	inventory_ui.closed.connect(set_player_gems)

func get_gem_list(main: bool) -> Array[Gem]:
	var res: Array[Gem] = []
	if main:
		for gem in avilable_gems:
			if gem.gem_type == Gem.type.main:
				res.append(gem)
		return res

	for gem in avilable_gems:
		match gem.gem_type:
			Gem.type.except:
				if gem.identity == main_gem.identity: continue
				res.append(gem)
			Gem.type.colorless:
				res.append(gem)
			Gem.type.only:
				if gem.identity == main_gem.identity: res.append(gem)
	return res

func set_gem(gem: Gem) -> void:
	if currently_swapped == -1: set_main_gem(gem)
	else: set_sub_gem(gem, currently_swapped)
	show_search_options.rpc_id(multiplayer.get_remote_sender_id(), false)

func set_main_gem(gem: Gem) -> void:
	main_gem = gem
	for i in range(len(sub_gems)):
		remove_sub_gem(i)
	gem_slots[0].gem = gem

func set_sub_gem(gem: Gem, idx: int) -> void:
	avilable_gems.erase(gem)
	if sub_gems[idx] != null:
		avilable_gems.append(sub_gems[idx]) # if occupied release to avilable group
	sub_gems[idx] = gem
	gem_slots[idx+1].gem = gem

func remove_sub_gem(idx: int) -> void: 
	if sub_gems[idx] == null: return
	avilable_gems.append(sub_gems[idx])
	sub_gems[idx] = null
	gem_slots[idx+1].gem = null


## Applying

@rpc("any_peer", "call_local", "reliable")
func remove_all_effects() -> void:
	for key in host.effects.keys():
		if not host.effects[key].temporary:
			host.remove_effect(key)
			
@rpc("any_peer", "call_local", "reliable")
func give_effects() -> void:
	host.add_passive(main_gem.passive)
	for gem in sub_gems:
		if gem != null:
			host.add_passive(gem.passive)

func set_player_gems() -> void:
	remove_all_effects.rpc_id(1)
	give_effects.rpc_id(1)

## UI

@rpc("authority", "call_local", "reliable")
func swap_visibility(value: bool) -> void:
	inventory_ui.visible = value
	if value: EscapeManager.currently_cancellable_ui = inventory_ui
	elif EscapeManager.currently_cancellable_ui == inventory_ui: 
		EscapeManager.currently_cancellable_ui = null

func on_gem_pressed(idx: int = -1) -> void:
	swap_gem.rpc_id(1, idx)

@rpc("any_peer", "call_local", "reliable")
func swap_gem(idx: int = -1) -> void:
	var list_of_gems: Array[Gem] = get_gem_list(idx == -1)
	search_menu.set_gem_options(list_of_gems)
	show_search_options.rpc_id(multiplayer.get_remote_sender_id(), true)
	currently_swapped = idx

@rpc("authority", "call_local", "reliable")
func show_search_options(value: bool) -> void:
	search_menu.visible = value
