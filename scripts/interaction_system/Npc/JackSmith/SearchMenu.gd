extends Control
class_name SearchMenu

signal gem_selected(gem: Gem)
signal gem_removed()

@export var option_container: Control
@export var option_scene: PackedScene

func set_gem_options(gems: Array[Gem]) -> void:
	if not multiplayer.is_server(): return
	for gem in gems:
		var tmp: GemOption = option_scene.instatiate()
		tmp.selected.connect(func(g: Gem): gem_select.rpc_id(1, g)) # Makes that option is updated in server
		option_container.add_child(tmp)
		tmp.gem = gem

@rpc("any_peer", "call_local", "reliable")
func gem_select(gem: Gem) -> void:
	if not multiplayer.is_server(): return
	if gem == null: gem_removed.emit()
	else: gem_selected.emit(gem)
