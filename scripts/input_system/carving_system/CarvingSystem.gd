extends Node
class_name CarvingSystem

signal successful_carving(rune: PackedScene) ## Po ukończeniu rycia wysyła sygnał dający scene z runą

@export var carvings: Array[Carvings]
@export var max_carvings: int = 4
@export var ui: Array[CarvingUI]

func _ready() -> void:
	successful_carving.connect(success_test)
	for i in range(max_carvings):
		if carvings[i] == null: 
			ui[i].visible = false
			continue
		ui[i].visible = true
		ui[i].set_pattern(carvings[i].pattern)
		
func start_carving() -> void: ## Rozpocznij rycie/ wyczyść
	for c in carvings:
		if c != null:
			c.restart()

func carve_symbol(symbol: int) -> void: ## Dodaj symbol do runy
	var i := 0
	for carve in carvings:
		if carve == null: continue
		if carve.misspelled: continue
		var correct := carve.next_symbol(symbol)
		if correct: ui[i].correct()
		else: ui[i].reset()
		i += 1
	chek_and_reset()

func chek_and_reset() -> void:
	for c in carvings:
		if c == null: continue
		if not c.misspelled: return
	for c in carvings:
		if c != null:
			c.restart()

func stop_carving() -> void: ## Ukończ rycie
	for carve in carvings:
		if carve == null: continue
		if carve.can_get_rune():
			successful_carving.emit(carve.rune)
			break
	for c in carvings:
		if c != null:
			c.restart()
	for u in ui:
		u.reset()

func carving_state_change(value: bool) -> void:
	if value: start_carving()
	else: stop_carving()

func success_test(rune:PackedScene) -> void:
	print("Done!")
