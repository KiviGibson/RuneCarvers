extends Node
class_name CarvingUI

const fragment_scene: PackedScene = preload("res://scenes/PatternFragmentUI.tscn")
const up: CompressedTexture2D = preload("res://kenney_cursor-pack/PNG/Basic/Default/arrow_n.png")
const down: CompressedTexture2D = preload("res://kenney_cursor-pack/PNG/Basic/Default/arrow_s.png")
const left: CompressedTexture2D = preload("res://kenney_cursor-pack/PNG/Basic/Default/arrow_w.png")
const right: CompressedTexture2D = preload("res://kenney_cursor-pack/PNG/Basic/Default/arrow_e.png")

@export var status_icon: TextureRect
@export var carving_node: Control
@export var name_code: Label 
@export var fragments: Array[PatternFragmentUI]

var current_fragment: int

func set_pattern(pattern: Array[int]) -> void:
	while carving_node.get_child_count() > 0:
		carving_node.remove_child(carving_node.get_child(0))
	for i in pattern:
		var tmp: PatternFragmentUI = fragment_scene.instantiate()
		match i:
			0: tmp.texture = up
			1: tmp.texture = down
			2: tmp.texture = left
			3: tmp.texture = right
		carving_node.add_child(tmp)
		fragments.append(tmp)

func correct() -> void:
	fragments[current_fragment].correct()
	current_fragment += 1

func reset() -> void:
	for i in range(current_fragment):
		fragments[i].reset()
	current_fragment = 0
