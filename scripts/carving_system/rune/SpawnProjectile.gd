extends CustomNode
class_name SpawnProjectile

@export var projectile_scene: PackedScene
@export var reverse: bool = false
func spawn_projectile(u: HurtBox = null) -> void:
	var res: Projectile
	if u:
		res = Projectiles.spawn({
			"scene": projectile_scene.resource_path, 
			"position": u.global_position}
			)
	else:
		res = Projectiles.spawn({
			"scene": projectile_scene.resource_path, 
			"position": host.model.global_position}
			)
		res.rotation = host.model.visible_model.rotation - Vector3(0, PI, 0) * int(reverse)
	res.owning_unit = host


func spawn_projectile_at_position(position: Vector3 = Vector3.ZERO) -> void:
	var res := Projectiles.spawn({"scene": projectile_scene.resource_path, "position": position})
	if host: res.owning_unit = host

func spawn_projectile_on_unit() -> void:
		var res := host.add_projectile(projectile_scene)
		host.model.finish_force_movement.connect(res._destroy)

func charge_shot_spawn(val: float) -> void:
	var res: Projectile = Projectiles.spawn({
			"scene": projectile_scene.resource_path, 
			"position": host.model.global_position}
			)
	res.rotation = host.model.visible_model.rotation
	res.initial_y_velocity *= (2.0-val)
	res.initial_velocity *= val
	res.owning_unit = host
