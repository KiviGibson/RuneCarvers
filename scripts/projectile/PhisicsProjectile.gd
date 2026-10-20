extends Projectile
class_name PhysicsProjectile

signal bounce(position: Vector3)
@export var gravity: float = 9.81
@export var bounces: int = 0
@export var bounciness: float = 0.7
@export var initial_velocity: float = 0
@export var initial_y_velocity: float = 0.0

var gravity_delta_scale: float = 1.0
var start: Vector3



func _ready() -> void:
	velocity.y = initial_y_velocity
	start = self.global_position*Vector3(1,0,1)
	

func _physics_process(delta: float) -> void:
	if not multiplayer.is_server(): return
	var tmp := -basis.z*initial_velocity*gravity_delta_scale + (velocity.y-gravity*delta*gravity_delta_scale) * Vector3(0,1,0)
	if is_on_floor():
		if bounces > 0:
			if tmp.y < 0:
				tmp.y = -tmp.y*bounciness
				bounces -= 1
				bounce.emit()
		else:
			_destroy()
	velocity = tmp
	move_and_slide()
