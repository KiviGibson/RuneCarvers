@tool
extends MultiplayerSpawner
class_name ProjectileSpawner

@export var update_paths: bool: 
	set(value):
		clear_spawnable_scenes()
		var dir = DirAccess.open("res://scenes/projectiles/")
		for file in dir.get_files():
			if file == "": continue
			add_spawnable_scene("res://scenes/projectiles/" + file)

func _ready() -> void:
	spawn_function = spawn_projectile

func spawn_projectile(data: Dictionary) -> Node3D:
	var res := load(data["scene"]).instantiate() as Projectile
	res.position = data["position"]
	return res
