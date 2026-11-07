extends CharacterBody3D
class_name Projectile

signal change_ownership(owner: Unit)
signal expire(position: Vector3)

var owning_unit: Unit: 
	set(value):
		change_ownership.emit(value)
		owning_unit = value

func _destroy(_collider: HurtBox = null) -> void:
	if not multiplayer.is_server(): return
	expire.emit(global_position)
	self.queue_free()
