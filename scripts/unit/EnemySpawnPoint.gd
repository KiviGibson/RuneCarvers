extends Node3D
class_name EnemySpawnPoint
## Spawns enemy in point when this node is entering a tree
@export var enemy: EnemySpawner.enemy

func _ready() -> void:
	if not multiplayer.is_server(): return
	Enemies.spawn({
		"enemy": enemy,
		"position": global_position,
		"rotation": global_rotation
	})
