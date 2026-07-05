extends TextureRect
class_name PatternFragmentUI
@export var animator: AnimationPlayer

func correct() -> void:
	animator.stop()
	animator.play("correct")
	
func reset() -> void:
	animator.stop()
	animator.play("reset")
