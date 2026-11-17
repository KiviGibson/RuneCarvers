extends Node
class_name CarvingSystem

signal successful_carving(rune: PackedScene) ## Po ukończeniu rycia wysyła sygnał dający scene z runą

var carvings: Array[Carvings] = []
@export var max_carvings: int = 4
@export var ui: Array[CarvingUI]
var enabled: bool = false

func start_carving() -> void: ## Rozpocznij rycie
	if not multiplayer.is_server(): return

func switch_carving(val: bool) -> void: enabled = val

func carve_symbol(symbol: int) -> void: ## Dodaj symbol do run i uaktualnij UI
	if enabled: return
	var i := -1
	for carve in carvings:
		i += 1
		if carve == null: 
			continue
		if carve.misspelled: continue
		var correct := carve.next_symbol(symbol)
		if correct: ui[i].correct()
		else: ui[i].reset()
	chek_and_reset()
	
func _process(delta: float) -> void: ## Update cd rycin
	if not multiplayer.is_server(): return
	var i := 0
	for c in carvings:
		if not c: continue
		if c.on_cd:
			var off_cd := c.tick_cooldown(delta)
			if off_cd:
				ui[i].able_to_use()
			else:
				ui[i].update_status(c.current_cd/c.cd)
		i += 1

func chek_and_reset() -> void: # Sprawdza czy przynajmniej jedna rycina jest poprawna w innym przypadku resetuje wszystkie ryciny
	for c in carvings:
		if c == null: continue
		if not c.misspelled: return
	for c in carvings:
		if c != null:
			c.restart()

func stop_carving() -> void: ## Ukończ rycie. Wykonuje [sygnał successful_carving] przy pierwszej poprawnej rycinie oraz resetuje UI
	if not multiplayer.is_server(): return
	for carve in carvings:
		if carve == null: continue
		if carve.can_get_rune():
			successful_carving.emit(carve.get_rune())
			break
	for c in carvings:
		if c != null:
			c.restart()
	for u in ui:
		u.reset()

func carving_state_change(value: bool) -> void: ## Funkcja zarządzająca [Input] zmianą stanu rycia
	if not multiplayer.is_server(): return
	if value: start_carving()
	else: stop_carving()

# Find carving by name
func find_carving(carving_name: String) -> Carvings:
	for carving in carvings:
		if carving.resource_name == carving_name:
			return carving
	return null

# Converts list of tools to carvings and swaps current carvings
func swap_tools(tools: Array[Tool]) -> void:
	var new_carvings: Array[Carvings]
	for tool in tools:
		if not tool: 
			print("added empty rune")
			new_carvings.append(null)
			continue
		var carving: Carvings = find_carving(tool.resource_name)
		if carving:
			print("added old rune")
			new_carvings.append(carving)
			continue
		print("added new rune")
		new_carvings.append(Carvings.new(tool))
	print("Finished")
	carvings = new_carvings

# Makes UI display proper carvings
func display_carvings() -> void:
	for i in range(max_carvings):
		if carvings[i] == null:
			ui[i].visible = false
			continue
		ui[i].visible = true
		ui[i].set_pattern(carvings[i].pattern)
		ui[i].name_code.text = carvings[i].resource_name
		ui[i].rune_icon = load(carvings[i].icon_path)
