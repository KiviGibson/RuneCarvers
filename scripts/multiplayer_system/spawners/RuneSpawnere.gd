extends MultiplayerSpawner
class_name RuneSpawner

@export var host: Unit
### data = {
### scene_path: String
### }

func _ready() -> void: spawn_function = spawn_rune

func spawn_rune(data: Dictionary) -> Rune:
	var tmp : Rune
	if data["rune"] is EncodedObjectAsID:
		var rune_obj : EncodedObjectAsID = data["rune"]
		tmp = instance_from_id(rune_obj.object_id).instantiate()
	elif data["rune"] is PackedScene:
		tmp = data["rune"].instantiate()
	tmp.setup.emit(host)
	tmp.empty.connect(host.remove_rune)
	return tmp
