extends Resource
class_name Carvings ## Resource Gameplay Specific generated

@export var pattern: Array[int]
@export var rune: PackedScene
var misspelled: bool = false ## Blokuje rune
var current_symbol: int = 0
var cd: float = 1.0

func next_symbol(symbol: int) -> bool: ## Dodaj symbol do kombinacji - Zwraca czy to poprawny symbol
	if misspelled: return false
	if current_symbol >= len(pattern):
		misspelled = true
		return false
	if symbol == pattern[current_symbol]:
		current_symbol += 1
		return true
	else:
		misspelled = true
		return false

func restart() -> void: ## Czyści aktualną próbę wykonania kombinacji
	misspelled = false
	current_symbol = 0

func can_get_rune() -> bool: ## Sprawdza czy kombinacja została poprawnie wprowadzona
	return current_symbol == len(pattern) and not misspelled

func get_rune() -> PackedScene: ## Zwraca działającą runę
	return rune
