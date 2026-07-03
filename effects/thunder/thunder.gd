extends Node3D
@onready var animator := $AnimationPlayer

func _ready() -> void:
	animator.stop()
	animator.play("thunder")
