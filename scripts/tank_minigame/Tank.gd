extends CharacterBody3D
class_name Tank

const forward: Array[Vector3] = [
	Vector3(-1,0,0), 
	Vector3(0,0,1),
	Vector3(1,0,0), 
	Vector3(0,0,-1)
]

enum task{move_forward = 0, move_backward, rotate_right, rotate_left}
enum dir{left, top, right, down}

signal tank_stopped(hit: bool)

@export var moves: Array[task]
@onready var dest: Vector3 = global_position
@export var timer: Timer
@export var forward_cast: RayCast3D
@export var back_cast: RayCast3D
@export var shoot_cast: RayCast3D
@export var direction: dir 

var dest_rot: float
var rot_delta: int = 0
var current_rot: float

func _ready() -> void:
	if not multiplayer.is_server(): return
	dest_rot = (PI/2)* direction - PI
	current_rot = dest_rot

func add_task(val: int) -> void:
	if not multiplayer.is_server(): return
	match val:
		0: moves.append(task.move_forward)
		1: moves.append(task.move_backward)
		2: moves.append(task.rotate_left)
		3: moves.append(task.rotate_right)

func start_task() -> void:
	if not multiplayer.is_server() or not timer.is_stopped(): return
	if  len(moves) == 0: 
		tank_stopped.emit(shoot_cast.get_collider() is Tank)
		return
	match moves.pop_front():
		task.move_forward:
			if not forward_cast.is_colliding():
				dest += forward[int(direction)]
		task.move_backward:
			if not back_cast.is_colliding():
				dest -= forward[int(direction)]
		task.rotate_left:
			direction = (direction + 1) % 4 as dir
			dest_rot += PI/2
			rot_delta = 1
		task.rotate_right:
			direction = direction - 1 as dir
			if direction < 0:
				direction = 3 as dir
			dest_rot -= PI/2
			rot_delta = -1
	timer.start()

func complete_move_task() -> void:
	if not multiplayer.is_server(): return
	if (global_position*Vector3(1, 0, 1)).distance_to(dest*Vector3(1, 0, 1)) < 0.01 and abs(current_rot-dest_rot) < 0.05:
		global_position = dest*Vector3(1, 0, 1) + global_position*Vector3(0, 1, 0)
		current_rot = dest_rot
		rot_delta = 0

func _physics_process(delta: float) -> void:
	if not multiplayer.is_server(): return
	current_rot += rot_delta*delta*PI/2
	basis.z = Vector3(cos(current_rot),0, -sin(current_rot))
	basis.x = Vector3(sin(current_rot),0, cos(current_rot))
	global_position.x = move_toward(global_position.x, dest.x, delta)
	global_position.z = move_toward(global_position.z, dest.z, delta)
	complete_move_task()
	if is_on_floor():
		velocity = Vector3.ZERO
	else:
		velocity.y += -9.81
	move_and_slide()

func start_next_task() -> void:
	if not multiplayer.is_server(): return
	start_task()

## Jeżeli czołgi jadą przed siebie a są w dystansie jednej kratki explodują i jest remis
## Lub odbijają się do ostatniego poprawnego ruchu do rozstrzygnięcia
