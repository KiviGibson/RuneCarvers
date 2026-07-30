extends Node3D
class_name EnemySpawnPoint

@export var enemy: EnemySpawner.enemy

func _ready() -> void:
	if not multiplayer.is_server(): return
	Enemies.spawn({
		"enemy": enemy,
		"position": global_position,
		"rotation": global_rotation
	})
