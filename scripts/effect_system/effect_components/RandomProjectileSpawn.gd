extends CustomNode
class_name RandomProjectileSpawn

@export var list: Dictionary[PackedScene, float]

func spawn_projectile() -> void:
	var prob := randf()
	var idx := 0
	while true: 
		prob -= list[list.keys()[idx]]
		if prob < 0: break
		idx += 1
		idx %= len(list) 
	var res: Projectile = Projectiles.spawn({
			"scene": list.keys()[idx].resource_path, 
			"position": host.model.global_position}
			)
	res.rotation = Vector3(0, randf()*2*PI, 0)
