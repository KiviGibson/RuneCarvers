extends CustomNode
class_name Inventory

@export var main_gem: Gem # on -1
@export var sub_gems: Array[Gem] # from 0 to 2
@export var avilable_gems: Array[Gem] # list of avilebility
@export var search_menu: SearchMenu
@export var inventory_ui: Control
var currently_swapped: int = -1

func get_gem_list(main: bool) -> Array[Gem]:
	var res: Array = []

	if main:
		for gem in avilable_gems:
			if gem.gem_type == Gem.type.main:
				res.append(gem)
		return res

	for gem in avilable_gems:
		match gem.gem_type:
			Gem.type.except:
				if gem.gem_type == main_gem.gem_type: continue
				res.append(gem)
			Gem.type.colorless:
				res.append(gem)
			Gem.type.only:
				if gem.gem_type == main_gem.gem_type: res.append(gem)
	return res

func set_gem(gem: Gem) -> void:
	if currently_swapped == -1: set_main_gem(gem)
	else: set_sub_gem(gem, currently_swapped)
		
func set_main_gem(gem: Gem) -> void: 
	main_gem = gem
	for i in range(len(sub_gems)):
		remove_sub_gem(i)

func set_sub_gem(gem: Gem, idx: int) -> void:
	avilable_gems.erase(gem)
	if sub_gems[idx] != null:
		avilable_gems.append(sub_gems[idx]) # if occupied release to avilable group
	sub_gems[idx] = gem

func remove_sub_gem(idx: int) -> void: 
	if sub_gems[idx] == null: return
	avilable_gems.append(sub_gems[idx])
	sub_gems[idx] = null

## UI
func show() -> void:
	swap_visibility.rpc()

@rpc("authority", "call_local", "reliable")
func swap_visibility() -> void:
	inventory_ui.visible = !inventory_ui.visible

func on_gem_pressed(idx: int = -1) -> void:
	swap_gem.rpc_id(1, idx)

@rpc("any_peer", "call_local", "reliable")
func swap_gem(idx: int = -1) -> void:
	var list_of_gems := get_gem_list(idx == -1)
	search_menu.set_gem_options(list_of_gems)
	show_search_options.rpc_id(host.owner_id)
	currently_swapped = idx

@rpc("authority", "call_local", "reliable")
func show_search_options() -> void:
	search_menu.visible = true
