extends Node
class_name SpawnEnemies
@export var Spawn_points: Array[Node3D]
@export var enemy_type: EnemySpawner.enemy

func spawn() -> void:
	for point in Spawn_points:
		Enemies.spawn({
			"enemy": enemy_type,
			"position": point.global_position,
			"rotation": point.rotation,
		})
