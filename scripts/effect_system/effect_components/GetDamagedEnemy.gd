extends Area3D
class_name GetDamaged

signal enemy_hit(damage: Damage)
signal activation()

@export var player_req: bool = true ## Require damage of plahyer to trigger
@export var atacks_per_activation: int = 0
@export var timer: Timer

var current_counter: int = 0

func _ready() -> void:
	area_entered.connect(on_hurtbox_enter)
	area_exited.connect(on_hurtbox_exit)

func on_hurtbox_enter(area: Area3D) -> void:
	if area is HurtBox: area.got_hit.connect(hit_recieved)
func on_hurtbox_exit(area: Area3D) -> void:
	if area is HurtBox: area.got_hit.disconnect(hit_recieved)

func hit_recieved(damage: Damage) -> void:
	if player_req and damage.owner is not Player: return
	enemy_hit.emit(damage)
	timer.start()
	current_counter += 1
	if atacks_per_activation <= current_counter: activation.emit()

func reset_effect() -> void: 
	current_counter = 0
