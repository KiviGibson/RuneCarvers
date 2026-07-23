extends MultiplayerSpawner
class_name FragmentSpawner

const fragment_scene: PackedScene = preload("res://scenes/carving_ui/PatternFragmentUI.tscn")
const up: CompressedTexture2D = preload("res://kenney_cursor-pack/PNG/Basic/Default/arrow_n.png")
const down: CompressedTexture2D = preload("res://kenney_cursor-pack/PNG/Basic/Default/arrow_s.png")
const left: CompressedTexture2D = preload("res://kenney_cursor-pack/PNG/Basic/Default/arrow_w.png")
const right: CompressedTexture2D = preload("res://kenney_cursor-pack/PNG/Basic/Default/arrow_e.png")

func _ready() -> void:
	spawn_function = spawn_fragment
	
func spawn_fragment(direction: int) -> PatternFragmentUI:
	var tmp: PatternFragmentUI = fragment_scene.instantiate()
	match direction:
		0: tmp.texture = up
		1: tmp.texture = down
		2: tmp.texture = left
		3: tmp.texture = right
	return tmp
