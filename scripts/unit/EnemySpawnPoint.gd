extends Node3D
class_name EnemySpawnPoint
## Spawns enemy in point when this node is entering a tree
@export var enemy: EnemySpawner.enemy
@export var max_distance: float = 0.0
@export var enemy_count: int = 1
func _ready() -> void:
	if not multiplayer.is_server(): return
	for i in range(enemy_count):
		Enemies.spawn({
			"enemy": enemy,
			"position": global_position + Vector3(randf(), 0, randf())*max_distance,
			"rotation": global_rotation
		})
