extends Node
class_name CarvingSystem

signal successful_carving(rune: PackedScene) ## Po ukończeniu rycia wysyła sygnał dający scene z runą

@export var carvings: Array[Carvings]
@export var max_carvings: int = 4
@export var ui: Array[CarvingUI]

func _ready() -> void:
	if not multiplayer.is_server(): return
	successful_carving.connect(success_test)
	for i in range(max_carvings):
		if carvings[i] == null: 
			ui[i].visible = false
			continue
		ui[i].visible = true
		carvings[i] = carvings[i].duplicate(true)
		ui[i].set_pattern(carvings[i].pattern)
		
func start_carving() -> void: ## Rozpocznij rycie/ wyczyść
	if not multiplayer.is_server(): return
	for c in carvings:
		if c != null:
			c.restart()

func carve_symbol(symbol: int) -> void: ## Dodaj symbol do runy
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
	
func _process(delta: float) -> void:
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

func chek_and_reset() -> void:
	for c in carvings:
		if c == null: continue
		if not c.misspelled: return
	for c in carvings:
		if c != null:
			c.restart()

func stop_carving() -> void: ## Ukończ rycie
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

func carving_state_change(value: bool) -> void:
	if not multiplayer.is_server(): return
	if value: start_carving()
	else: stop_carving()

func success_test(_rune:PackedScene) -> void:
	print("Done: " + get_parent().name)
