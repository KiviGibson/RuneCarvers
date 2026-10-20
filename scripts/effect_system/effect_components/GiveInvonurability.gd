extends CustomNode
class_name GiveInvonurability

@export var time: float

func activate() -> void:
	host.hurt_box._set_invincibility_frames(time)
