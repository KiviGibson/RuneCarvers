extends CSGMesh3D

@onready var noise_y: float = 0.0

func _process(delta: float) -> void:
	var mat := material as ShaderMaterial
	if not mat:
		return
	
	mat.set_shader_parameter("elevation", position.y - (mesh.size.y/2.0)*cos(rotation.z))
	
	var player_id: Array[int] = Players.get_player_ids()
	if len(player_id) == 2:
		var players: Array[Player] = [Players.get_player(player_id[0]), Players.get_player(player_id[1])]
		mat.set_shader_parameter("player1_pos", players[0].model.global_position)
		mat.set_shader_parameter("player2_pos", players[1].model.global_position)
		
		noise_y += delta*0.1
		mat.set_shader_parameter("noise_y", noise_y)
		
	
