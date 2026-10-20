extends MeshInstance3D
class_name FrostbiteVis

@export var animator: AnimationPlayer
@export var host: Effect

func _ready() -> void:
	self.material_override = material_override.duplicate(true)
	animator.play(&"new_animation")

func stack_erned(val: int) -> void:
	if multiplayer.is_server(): 
		update_vis.rpc(val)

@rpc("authority", "reliable", "call_local")
func update_vis(val: int) -> void:
	var mat:= self.material_override as ShaderMaterial
	mat.set_shader_parameter("angle_value", float(val))
	animator.stop()
	animator.play(&"new_animation")
