@tool
extends MultiplayerSpawner
class_name EffectSpawner

@export var host: Unit
@export var update_paths: bool: 
	set(value):
		clear_spawnable_scenes()
		var dir = DirAccess.open("res://scenes/effects/")
		for file in dir.get_files():
			if file == "": continue
			add_spawnable_scene("res://scenes/effects/" + file)

func _ready() -> void:
	spawn_function = spawn_effect

func spawn_effect(data: Dictionary) -> Effect:
	var tmp: Effect = load(Effect.str_to_path[data["effect"]]).instantiate()
	tmp.host = host
	tmp.effect_name = data["effect"]
	if data["owner"] is Unit:
		tmp.owner_unit = data["owner"]
	elif data["owner"] is EncodedObjectAsID:
		tmp.owner_unit = instance_from_id(data["owner"].object_id)
	return tmp
