extends CustomNode
class_name RemoteHost

signal remote_setup(h: Unit)

func setup(h: Unit) -> void:
	super.setup(h)
	if h is Player:
		for i in Players.get_player_ids():
			if i != h.owner_id:
				print(i)
				remote_setup.emit(Players.get_player(i))
				return
