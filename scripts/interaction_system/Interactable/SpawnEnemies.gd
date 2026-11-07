extends Node
class_name SpawnEnemies
@export var Spawn_points: Array[Node3D]
@export var enemy_type: EnemySpawner.enemy
@export var count: int = 1
@export var max_distance: float = 1
func spawn(_id: int = 0) -> void:
	for point in Spawn_points:
		for i in range(count):
			Enemies.spawn({
				"enemy": enemy_type,
				"position": point.global_position + Vector3(randf(), 0, randf())*max_distance,
				"rotation": point.rotation,
			})
