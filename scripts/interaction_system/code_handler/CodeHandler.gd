extends Node3D
class_name CodeHandler
# Class for displaying code of interaction area aka. Tank Minigame 
@export var code_length: int
@export var hidden_code: bool
@export var display: RichTextLabel
@export var sub_view: SubViewport
var current_text: String = ""
var current_length: int = 0

@export_group("filler pattern")
@export var use_expected_signs: bool
@export var expected_signs: Array[int]

@export_group("paths")
@export_file(".png") var hidden_sign: String
@export_file(".png") var empty_sign: String
@export_file(".png") var signs: Array[String]

func setup() -> void:
	#set label that shows how many points is needed
	if use_expected_signs and len(expected_signs)< code_length:
		expected_signs = []
		for i in range(code_length): expected_signs.append(-1)
	sub_view.size.x = 32 * code_length
	write_to_screen()

func add_sign(signum: int) -> void:
	current_length += 1
	if current_length > code_length: 
		reset()
		return
	if hidden_code: current_text += "[img]"+hidden_sign+"[/img]"
	else: current_text += "[img]"+signs[signum]+"[/img]"
	write_to_screen()

func reset() -> void:
	current_length = 0
	current_text = ""
	write_to_screen()

func write_to_screen() -> void:
	display.text = current_text
	for i in range(current_length, code_length):
		if use_expected_signs:
			if expected_signs[i] == -1: display.text += "[img color=gray]"+empty_sign+"[/img]"
			else: display.text += "[img color=gray]"+signs[expected_signs[i]]+"[/img]"
		else: display.text += "[img color=gray]"+empty_sign+"[/img]"
