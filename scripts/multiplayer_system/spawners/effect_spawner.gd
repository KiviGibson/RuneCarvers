@tool
extends MultiplayerSpawner
class_name EffectSpawner

@export var host: Unit


func _ready() -> void:
	spawn_function = spawn_effect

func spawn_effect(data: Dictionary) -> Effect:
	var tmp: Effect
	if data["type"] == "status":
		tmp = load(Effect.str_to_path[data["effect"]]).instantiate()
		tmp.effect_name = data["effect"]
		tmp.host = host
	elif data["type"] == "passive":
		tmp = load(data["effect"]).instantiate()
		tmp.host = host
		tmp.effect_name = tmp.name
	if data["owner"] is Unit:
		tmp.owner_unit = data["owner"]
	elif data["owner"] is EncodedObjectAsID:
		tmp.owner_unit = instance_from_id(data["owner"].object_id)
	return tmp
