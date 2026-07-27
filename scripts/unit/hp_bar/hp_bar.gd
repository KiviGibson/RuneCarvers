extends Control
class_name HpBar

@export var timer: Timer
@export var current_progress_bar: ProgressBar
@export var gray_progress_bar: ProgressBar
@export var hide_on_max: bool
var damage_delay_excited: bool = false

func _ready() -> void:
	timer.timeout.connect(func() -> void: damage_delay_excited = true)
	if hide_on_max: modulate.a = 0

@rpc("authority", "call_local", "reliable")
func health_change(current: int, absolute: int) -> void:
	if absolute == 0: return
	var percent: float = float(current)/float(absolute)
	if percent > current_progress_bar.value: percent_gain(percent)
	elif percent < current_progress_bar.value: percent_loss(percent)

func percent_gain(new_value: float) -> void:
	current_progress_bar.value = new_value
	if gray_progress_bar.value < current_progress_bar.value:
		gray_progress_bar.value = new_value

func percent_loss(new_value: float) -> void:
	modulate.a = 1
	current_progress_bar.value = new_value
	damage_delay_excited = false
	timer.start()

func _process(delta: float) -> void:
	if damage_delay_excited: 
		gray_progress_bar.value = move_toward(gray_progress_bar.value, current_progress_bar.value, delta*2)
	if current_progress_bar.value >= 0.99 and hide_on_max:
		print(current_progress_bar.value)
		modulate.a = move_toward(modulate.a, 0, delta*4)
