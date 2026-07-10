extends Resource
class_name Carving ## GamePlay Specyfic Resource

@export var pattern: Array[int]
@export var rune: PackedScene
@export var cd: float = 1.0

var misspelled: bool = false ## Blokuje rune
var current_symbol: int = 0
var current_cd: float = 0.0
var on_cd: bool = false


func next_symbol(symbol: int) -> bool: ## Dodaje symbol do kombinacji - Zwraca czy to poprawny symbol
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
	return current_symbol == len(pattern) and not misspelled and not on_cd

func get_rune() -> PackedScene: ## Zwraca działającą runę
	current_cd = cd
	on_cd = true
	return rune

func tick_cooldown(delta: float) -> bool: ## Odlicza czas zwraca czy umiejętność zmieniła stan na aktywny
	if on_cd:
		current_cd -= delta
		if current_cd <= 0:
			on_cd = false
			return true
	return false
