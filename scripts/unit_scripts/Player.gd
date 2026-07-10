extends Unit
class_name Player

@export var input_system: InputSystem
@export var carving_system: CarvingSystem
@export var carving_ui: Control ## Reparents to game overlay node
@export var camera: Camera3D
var owner_id: int

func _ready() -> void:
	enable_camera()
	super._ready()

func enable_camera() -> void:
	if owner_id != multiplayer.get_unique_id():
		model.remove_child(camera)
		camera.free()

func _on_health_change(_curernt: int, _max_value: int) -> void: pass # UpdateUI
func _on_health_depleated() -> void: pass # Death func
