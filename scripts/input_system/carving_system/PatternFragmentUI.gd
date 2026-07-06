extends TextureRect
class_name PatternFragmentUI
@export var animator: AnimationPlayer

func _ready() -> void:
	animator.play("RESET")

func correct() -> void:
	animator.stop()
	animator.play("correct")
	
func reset() -> void:
	animator.stop()
	animator.play("reset")
