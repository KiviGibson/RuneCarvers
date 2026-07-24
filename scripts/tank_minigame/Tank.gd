extends CharacterBody3D
class_name Tank
enum task{move_forward, move_backward, rotate_right, rotate_left}
enum dir{left, top, right, down}

const forward: Array[Vector3] = [
	Vector3(-1,0,0), 
	Vector3(0,0,1),
	Vector3(1,0,0), 
	Vector3(0,0,-1)
]

@export var moves: Array[task]
@onready var dest: Vector3 = global_position
@export var timer: Timer
var dest_rot: float
@export var direction: dir 
var rot_delta: int = 0
var current_rot: float

func _ready() -> void:
	dest_rot = 2*PI* direction
	current_rot = dest_rot
	start_task()

func add_task(val: int) -> void:
	match val:
		0: moves.append(task.move_forward)
		1: moves.append(task.move_backward)
		2: moves.append(task.rotate_left)
		3: moves.append(task.rotate_right)

func start_task() -> void:
	if  len(moves) == 0: return
	match moves.pop_front():
		task.move_forward: 
			dest += forward[int(direction)]
		task.move_backward:
			dest -= forward[int(direction)]
		task.rotate_right:
			direction = direction + 1 as dir
			dest_rot += PI/2
			rot_delta = 1
		task.rotate_left:
			direction = direction - 1 as dir
			dest_rot -= PI/2
			rot_delta = -1
	timer.start()

func complete_move_task() -> void:
	if global_position.distance_to(dest) < 0.001 and abs(current_rot-dest_rot) < 0.05:
		global_position = dest
		current_rot = dest_rot
		rot_delta = 0

func _physics_process(delta: float) -> void:
	current_rot += rot_delta*delta*PI/2
	basis.z = Vector3(cos(current_rot),0, -sin(current_rot))
	basis.x = Vector3(sin(current_rot),0, cos(current_rot))
	global_position.x = move_toward(global_position.x, dest.x, delta)
	global_position.z = move_toward(global_position.z, dest.z, delta)
	complete_move_task()

func start_next_task() -> void:
	start_task()
