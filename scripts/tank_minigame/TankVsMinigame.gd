extends Node
class_name TankVsMinigame
@export var tanks: Array[Tank]
@export var input: Array[CarvingInterationZone]
@export var pattern_length: int
var player_patterns: Array[Array] = [[], []]
var locked_patterns: int = -1


var round_started: bool
var tanks_finshed_results: Dictionary[int, bool]


func _ready() -> void:
	for i in range(len(input)):
		input[i].carved_symbol.connect(func(val: int) -> void: on_input_recieved(val, i))
		input[i].interaction_ended.connect(func() -> void: on_input_accept(i))
		tanks[i].tank_stopped.connect(func(val: int) -> void: checkout_tank(val, i))

func on_input_recieved(val: int, index: int) -> void:
	if locked_patterns == index or round_started: return
	if len(player_patterns[index]) == pattern_length: player_patterns[index] = []
	player_patterns[index].append(val)

func on_input_accept(index: int) -> void:
	if locked_patterns == index or round_started: return
	if not patterns_correct(index): 
		player_patterns[index] = []
		return
	print("Accepted pattern: " + str(index))
	for i in player_patterns[index]:
		tanks[index].add_task(i)
	if locked_patterns != -1:
		print("Round start")
		for tank in tanks:
			tank.start_task()
		locked_patterns = -1
		player_patterns = [[], []]
		round_started = true
	else:
		locked_patterns = index

func patterns_correct(index: int) -> bool:
	return len(player_patterns[index]) == pattern_length

func checkout_tank(val: bool, index: int) -> void:
	tanks_finshed_results[index] = val
	if len(tanks_finshed_results) == 2:
		print("Round finish")
		print_winners()
		tanks_finshed_results = {}
		round_started = false

func print_winners() -> void:
	if tanks_finshed_results[0] == tanks_finshed_results[1]: print("Remis")
	elif tanks_finshed_results[0]: print("Wygrał Lewy")
	else: print("Wygrał Prawy")
