extends Node
class_name CarvingSystem

signal successful_carving(rune: PackedScene) ## Po ukończeniu rycia wysyła sygnał dający scene z runą

@export var carvings: Array[Carving]
@export var max_carvings: int = 4
@export var ui: Array[CarvingUI]

func _ready() -> void:
	if not multiplayer.is_server(): return
	for i in range(max_carvings):
		if carvings[i] == null: 
			ui[i].visible = false
			continue
		ui[i].visible = true
		carvings[i] = carvings[i].duplicate(true)
		ui[i].set_pattern(carvings[i].pattern)
		
func start_carving() -> void: ## Rozpocznij rycie
	if not multiplayer.is_server(): return


func carve_symbol(symbol: int) -> void: ## Dodaj symbol do run i uaktualnij UI
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
