extends Node
class_name Inventory

signal start_changes()
signal added_tool(rune: PackedScene, icon: CompressedTexture2D, pattern: Array[int], cd: float)
signal add_passive(passive: PackedScene)

@export var tools: Array[CarvingTool]  = [null, null, null, null] # Max 4
@export var backpack: Backpack
@export var trinkets: Array[Trinket]  = [null, null, null, null] # Max 4
@export var inventory_ui: Control 
var is_editing: bool

func show_previev() -> void:
	is_editing = false
	inventory_ui.visible = true

func start_editing() -> void:
	is_editing = true
	inventory_ui.visible = true
	start_changes.emit()

func close() -> void:
	pass

func remove_tool(pos: int) -> void:
	tools[pos] = null

func add_tool(tool: CarvingTool, pos: int) -> bool:
	if tool in tools: return false
	tools[pos] = tool
	return true

func update_tools() -> void:
	for tool in tools:
		if tool == null: continue
		added_tool.emit(tool.rune, tool.icon, tool.pattern, tool.cooldown)

func update_trinkets() -> void:
	for trinket in trinkets:
		if trinket == null: continue
		add_passive.emit(trinket.passive)

func remove_trinket(pos: int) -> void:
	trinkets[pos] = null

func add_trinket(trinket: Trinket, pos: int) -> bool:
	if trinket in trinkets: return false
	trinkets[pos] = trinket
	return true
