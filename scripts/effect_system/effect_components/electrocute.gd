extends CustomNode
class_name Electrocute

@export var layer_added: int

func add_targeting() -> void:
	host.hurt_box.collision_layer += 2**(layer_added-1)

func remove_targeting() -> void:
	host.hurt_box.collision_layer -= 2**(layer_added-1)
