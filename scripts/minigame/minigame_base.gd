@abstract
class_name Minigame
extends Node3D

class InputData:
	var pattern: Array = []
	var is_locked: bool = false
	func reset() -> void:
		pattern.clear()
		is_locked = false

@export var input: Array[CarvingInterationZone]
## Length of the inputted pattern. If set to -1 the inputs will process in real time.
@export var pattern_length: int

var input_data: Array[InputData] = []

var round_started: bool
var tanks_finshed_results: Dictionary[int, bool]


func _ready() -> void:
	if not multiplayer.is_server(): return
	
	_inputs_signal_setup()

## Basic signal connections for [CarvingInterationZone]s
func _inputs_signal_setup() -> void:
	for i in range(len(input)):
		input_data.append(InputData.new())
		input[i].carved_symbol.connect(func(val: int) -> void: on_input_recieved(val, i))
		input[i].interaction_ended.connect(func() -> void: on_input_accept(i))
		input[i].code_handler.setup()

func _all_inputs_locked() -> bool:
	for inpd in input_data:
		if not (inpd.is_locked): return false
	#else:
	return true

func on_input_recieved(val: int, index: int) -> void:
	if input_data[index].is_locked or round_started: return
	
	if len(input_data[index].pattern) == pattern_length: 
		input_data[index].pattern.clear()
		input[index].code_handler.reset()
	
	input[index].code_handler.add_sign(val)
	input_data[index].pattern.append(val)

func on_input_accept(index: int) -> void:
	if pattern_length < 0: return
	if input_data[index].is_locked or round_started: return
	if not patterns_correct(index): 
		input_data[index].pattern.clear()
		input[index].code_handler.reset()
		return
	
	print("Accepted pattern: " + str(index))
	_on_input_locked(index)
	#for i in player_patterns[index]:
		#tanks[index].add_task(i)
	if _all_inputs_locked():
		print("Round start")
		_on_round_start()
		#for tank in tanks:
			#tank.start_task()
		for inpd in input_data:
			inpd.reset()
		round_started = true
	else:
		input_data[index].is_locked = true

func patterns_correct(index: int) -> bool:
	return len(input_data[index].pattern) == pattern_length

@abstract
func _on_round_start() -> void
@abstract
func _on_input_locked(index: int) -> void
