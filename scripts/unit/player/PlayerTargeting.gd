extends Node3D
class_name PlayerTargeting

var current_target: HurtBox = null
@export var targetting_area: Area3D
@export var area_collider: CollisionShape3D
@export var prio_ray: RayCast3D
@export var mv_controller: PlayerMovement
var enabled: bool = true
# Target oponent till he is dead or when playewr faces different oponent with prio cone

func get_oponent() -> void:
	if prio_ray.is_colliding():
		if current_target != prio_ray.get_collider():
			current_target = prio_ray.get_collider()
			return
	if current_target != null: return
	var candidate: HurtBox = null
	var candidate_distance: float = 0.0
	for current in targetting_area.get_overlapping_areas():
		if candidate == null:
			candidate = current as HurtBox
			candidate_distance = (
				self.global_position*Vector3(1, 0, 1)).distance_to(
					candidate.global_position*Vector3(1,0,1))
			continue
		var current_distance: float = (
			self.global_position*Vector3(1, 0, 1)).distance_to(
					current.global_position*Vector3(1,0,1))
		if current_distance < candidate_distance:
			candidate = current
			candidate_distance = current_distance
	current_target = candidate
	
func check_target() -> void:
	if current_target == null or current_target not in targetting_area.get_overlapping_areas():
		current_target = null

func _process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	check_target()
	get_oponent()
	if enabled and current_target != null:
		var x: float = current_target.global_position.x - self.global_position.x
		var y: float = current_target.global_position.z - self.global_position.z
		var dist:float = sqrt(x**2+y**2) 
		mv_controller.set_rotation_vector(Vector2(x/dist, y/dist))
	else: 
		mv_controller.set_rotation_vector(Vector2(-self.basis.z.x, -self.basis.z.z))


func set_rotation_vector(value: Vector2) -> void:
	if value == Vector2.ZERO: 
		return
	self.basis.z = Vector3(-value.x, 0, -value.y)
	self.basis.x = Vector3(-value.y, 0, value.x)

func switch_targeting() -> void:
	enabled = !enabled
