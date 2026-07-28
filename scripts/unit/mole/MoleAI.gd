extends Node3D
class_name MoleAI
@export var animator: AnimationPlayer
var hiding: bool = false
var shot: bool = false
func _ready() -> void:
	animator.animation_finished.connect(_animation_finished)
	
func _animation_finished(anim_name: StringName) -> void:
	animator.stop()
	match anim_name:
		&"idle":
			if shot: animator.play(&"hide")
			else: animator.play(&"shoot_strait")
		&"shoot_strait":
			shot = true
			animator.play(&"idle")
		&"hide":
			hiding = !hiding
			if hiding:
				animator.play_backwards(&"hide")
			else:
				shot = false
				animator.play(&"idle")
