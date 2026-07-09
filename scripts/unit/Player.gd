extends Unit
class_name Player

@export var input_system: InputSystem
@export var carving_system: CarvingSystem
@export var carving_ui: Control ## Reparents to game overlay node
@export var camera: Camera3D
var owner_id: int

func _ready() -> void:
	enable_camera()

func enable_camera() -> void:
	if owner_id != multiplayer.get_unique_id():
		model.remove_child(camera)
		camera.free()
	
