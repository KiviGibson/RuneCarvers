extends Projectile
class_name AnimatedProjectile

@export var animation_curve: Curve
@export var path: Path3D
@export var path_follow: PathFollow3D
@export var destroy_on_finish: bool = false
var current_value: float

@export var ray_cast: RayCast3D 
func _process(delta: float) -> void:
	path_follow.progress_ratio = animation_curve.sample(current_value)
	current_value += delta
	if destroy_on_finish and path_follow.progress_ratio == 1.0:
		_destroy()

func set_finish_on_floor() -> void:
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		path.curve.set_point_position(-1,ray_cast.get_collision_point())

func update_max_distance(distance: Vector3) -> void:
	path.curve.set_point_position(-1, distance)
