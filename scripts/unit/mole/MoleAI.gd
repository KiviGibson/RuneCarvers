extends Node3D
class_name MoleAI

signal changed_rotation(rot_vec: Vector2)

@export var animator: AnimationPlayer
@export var hole_finder: Area3D
@export var tp: Teleport
@export var timer_borrow: Timer
@export var strait_projectile: SpawnProjectile
@export var vision: Area3D
var current_target: Node3D
var current_hole: Hole

var hiding: bool = false
var shot: bool = false
var can_rotate: bool = true

func _ready() -> void:
	if not multiplayer.is_server(): return
	animator.animation_finished.connect(_animation_finished)
	if multiplayer.is_server(): 
		timer_borrow.timeout.connect(func(): un_borrow.rpc())

func _process(delta: float) -> void:
	if not multiplayer.is_server(): return
	if can_rotate: 
		if current_target == null: return
		changed_rotation.emit(Vector2(
			current_target.global_position.x - vision.global_position.x, 
			current_target.global_position.z-vision.global_position.z
			).normalized())

func _animation_finished(anim_name: StringName) -> void:
	if not multiplayer.is_server(): return
	match anim_name:
		&"idle":
			if current_target == null: shot = true
			if shot:
				if current_hole: current_hole.used = false
				animate.rpc(&"hide")
				can_rotate = true
			else:
				can_rotate = false
				animate.rpc(&"shoot_strait")
		&"shoot_strait":
			shot = true
			animate.rpc(&"idle")
		&"hide":
			hiding = !hiding
			if hiding:
				var obj: Hole = get_best_hole()
				if obj:
					current_hole = obj
					current_hole.used = true
				timer_borrow.start(randf())
				change_anim_spped.rpc(0.0)
				animate.rpc(&"hide", true)
			else:
				set_target()
				shot = false
				animate.rpc(&"idle")

@rpc("authority", "call_local", "reliable")
func un_borrow() -> void:
	if multiplayer.is_server():
		change_anim_spped.rpc(1.0)
		tp.teleport_to_position(current_hole.global_position)

@rpc("authority", "call_local", "reliable")
func change_anim_spped(value: float) -> void:
		animator.speed_scale = value

@rpc("authority", "call_local", "reliable")
func animate(anim_name: StringName, back_ward: bool = false) -> void:
	if back_ward: animator.play_backwards(anim_name)
	else: animator.play(anim_name)
func shoot() -> void:
	if multiplayer.is_server():
		strait_projectile.spawn_projectile()


func get_best_hole() -> Hole:
	var avilable_holes: Array[Node3D] = hole_finder.get_overlapping_bodies()
	var weight: Array[float] = []
	var hole_in_use := 100.0
	var current_hole_weight:= 10.0
	var player_close_weight:= 5.0
	for hole in avilable_holes:
		if hole is not Hole: 
			weight.append(200.0)
			continue
		var tmp := randf_range(-1, 1) + hole_in_use * int(hole.used)
		tmp += current_hole_weight * int(current_hole == hole)
		tmp += player_close_weight * int(hole.used)
		weight.append(tmp)
	var id := weight.find(weight.min())
	return avilable_holes[id]

func set_target() -> void:
	var same_target_weight: float = -2.0
	var closer_enemy_weight: float = 0.4
	var behind_the_wall_weight: float = 1.0
	var last: float = 100.0
	for unit in vision.get_overlapping_bodies():
		if unit is not MovementControler or unit.type != MovementControler.pupet_type.player: continue
		var current: float = (randf()-0.5) * 1.8
		current += same_target_weight * int(current_target == unit)
		current += clampf(closer_enemy_weight * (10 - vision.global_position.distance_to(unit.global_position)), -1, 20)
		if last > current:
			current_target = unit
			last = current
	if last == 100: current_target = null
