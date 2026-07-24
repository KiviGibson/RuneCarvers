extends Node
class_name CarvingUI

const temp_rune_icon: CompressedTexture2D = preload("res://icon.svg")
const clock_fill: Array[CompressedTexture2D] = [
	preload("res://assets/kenney_cursor-pack/Vector/Basic/progress_CW_25.svg"),
	preload("res://assets/kenney_cursor-pack/Vector/Basic/progress_CW_50.svg"),
	preload("res://assets/kenney_cursor-pack/Vector/Basic/progress_CW_75.svg"),
	preload("res://assets/kenney_cursor-pack/Vector/Basic/progress_full.svg"),
	temp_rune_icon
]
@export var status_icon: TextureRect
@export var carving_node: Control
@export var name_code: Label 
@export var animator: AnimationPlayer

@export var fragments: Array[PatternFragmentUI]
@export var spawner: FragmentSpawner

var current_fragment: int
var current_index: int = 0

func set_pattern(pattern: Array[int]) -> void:
	while carving_node.get_child_count() > 0:
		carving_node.remove_child(carving_node.get_child(0))
	for i in pattern:
		var tmp := spawner.spawn(i)
		fragments.append(tmp)

func correct() -> void:
	fragments[current_fragment].correct()
	current_fragment += 1

func reset() -> void:
	for i in range(current_fragment):
		fragments[i].reset()
	current_fragment = 0
	
func update_status(progress: float) -> void:
	var index := clampi(int(progress * 4), 0, 3)
	if index != current_index:
		current_index = index
		sync_clock.rpc(index)

func able_to_use() -> void:
	sync_clock.rpc(4)
	
@rpc("authority", "call_local", "unreliable")
func sync_clock(index: int) -> void:
	animator.stop()
	animator.play("timer_update")
	status_icon.texture = clock_fill[index]
