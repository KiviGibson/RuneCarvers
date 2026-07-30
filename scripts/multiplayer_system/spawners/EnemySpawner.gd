extends MultiplayerSpawner
class_name EnemySpawner

enum enemy{
	Goly,
	HoleMole
}

var enemy_scene: Dictionary [enemy, PackedScene] = {
	enemy.Goly: load(&"uid://b0766kma0i2rc"),
	enemy.HoleMole: load(&"uid://dwc03idkesqx2")
}

func _ready() -> void:
	spawn_function = spawn_func

func spawn_func(data: Dictionary) -> Enemy:
	var enemy_type: enemy = data["enemy"]
	var position: Vector3 = data["position"]
	var start_rotation: Vector3 = data["rotation"]
	var tmp: Enemy = enemy_scene[enemy_type].instantiate()
	tmp.position = position
	tmp.model.visible_model.rotation = start_rotation
	return tmp
