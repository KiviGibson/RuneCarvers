extends MultiplayerSpawner
class_name RuneSpawner

@export var host: Unit
### data = {
### scene_path: String
### }

func _ready() -> void: spawn_function = spawn_rune

func spawn_rune(data: Dictionary) -> Rune:
	var tmp : Rune
	tmp = instance_from_id(data["rune"]).instantiate()
	tmp.setup.emit(host)
	tmp.empty.connect(host.remove_rune)
	return tmp
