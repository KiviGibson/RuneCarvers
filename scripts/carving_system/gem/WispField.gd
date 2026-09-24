extends Area3D
class_name WispField

@export var timer: Timer
@export var wisp_spawner: SpawnProjectile
var wanderers: int = 0

func _ready() -> void:
	area_entered.connect(_on_wanderer_enter)
	area_exited.connect(_on_wanderer_exit)
	timer.timeout.connect(spawn_wisp)

func _on_wanderer_enter(collider: Area3D) -> void:
	if not multiplayer.is_server(): return
	if collider is not Collector: return
	wanderers += 1
	if wanderers >= 1 and timer.is_stopped():
		timer.start(randf_range(3.0, 10.0))

func _on_wanderer_exit(collider: Area3D) -> void:
	if not multiplayer.is_server(): return
	if collider is not Collector: return
	wanderers -= 1
	if wanderers <= 0:
		wanderers = 0
		timer.stop()

func spawn_wisp() -> void:
	if not multiplayer.is_server(): return
	var num := randi_range(0, get_child_count()-2)
	var child: CollisionShape3D = get_child(num)
	var size: Vector3 = child.shape.size
	var pos: Vector3 = child.global_position + Vector3(randf_range(-size.x/2, size.x/2), 1, randf_range(-size.z/2, size.z/2))
	wisp_spawner.spawn_projectile_at_position(pos)
	timer.start(randf_range(3.0, 10.0))
