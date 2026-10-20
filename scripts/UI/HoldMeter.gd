extends Node3D
class_name HoldMeter

@export var progress_bar: ProgressBar
@export var bar_container: HBoxContainer
@export var rune: Rune
var segment: int
@export var list: Array[AnimationPlayer]

func _ready() -> void:
	if rune: rune.charge_shot.connect(func(_v: float): reset.rpc())

func gather() -> void: 
	list.clear()
	for child in bar_container.get_children():
		if child.get_child_count() == 1:
			list.append(child.get_child(0))

func _process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	if rune and rune.charging:
		progress.rpc(rune.charged_value)

@rpc("authority", "reliable", "call_local")
func progress(val: float) -> void:
	progress_bar.value = val*100.0
	var tmp_segment := floori(val * 10)
	if tmp_segment >= segment:
		list[segment].play(&"new_animation")
		segment += 1

@rpc("authority", "reliable", "call_local")
func reset() -> void:
	for seg in list:
		seg.play(&"RESET")
	progress_bar.value = 0.0
	segment = 0
