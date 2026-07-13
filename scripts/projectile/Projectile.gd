extends CharacterBody3D
class_name Projectile

signal change_ownership(owner: Unit)
signal bounce(position: Vector3)
signal expire(position: Vector3)

@export var gravity: float = 9.81
@export var bounces: int = 0
@export var bounciness: float = 0.7
@export var initial_velocity: float = 0

var owning_unit: Unit: 
	set(value):
		change_ownership.emit(value)
		owning_unit = value

func _ready() -> void: pass

func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	var tmp := -basis.z*initial_velocity
	tmp.y -= gravity
	if is_on_floor():
		if bounces > 0:
			if tmp.y < 0:
				tmp.y = -tmp.y*bounciness
				bounces -= 1
				bounce.emit()
		else:
			expire.emit()
	velocity = tmp
	move_and_slide()

func _destroy(_collider: HurtBox = null) -> void:
	if not multiplayer.is_server(): return
	expire.emit(global_position)
	dest_rpc.rpc()


@rpc("authority", "call_local", "reliable")
func dest_rpc() -> void:
	self.queue_free()
	
