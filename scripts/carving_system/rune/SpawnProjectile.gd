extends Node
class_name SpawnProjectile

signal projectile_hit(collider: HurtBox)

@export var projectile_scene: PackedScene
var unit: Unit
func setup(u: Unit) -> void:
	unit = u
	
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
			"position": unit.model.global_position}
			)
		res.rotation = unit.model.visible_model.rotation
	res.owning_unit = unit


func spawn_projectile_at_position(position: Vector3 = Vector3.ZERO) -> void:
	var res := Projectiles.spawn({"scene": projectile_scene.resource_path, "position": position})
	res.owning_unit = unit
