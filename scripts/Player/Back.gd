extends StateBase

@export var player: Player

func enter() -> void:
	super.enter()
	#print("enter Idle")
	player.is_back = true
	player.move()
	if player.get_scene() and player.get_scene().PostEffect_CRT :
		player.get_scene().PostEffect_CRT.show()
		
	

func exit() -> void:
	pass
	
func process_update(delta: float) -> void:
	pass
	
func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	if player.is_follow_path and player.is_back:
		var last_pos = Vector3(player.path.global_position.x, player.global_position.y, player.path.global_position.z)
		player.path.progress = player.path.progress - player.back_speed * 0.01
		var new_pos = Vector3(player.path.global_position.x, player.global_position.y, player.path.global_position.z)
		player.velocity = (new_pos - last_pos) / delta

		if abs(player.velocity.x) + abs(player.velocity.z) > 0.1:
			var dir = Vector2(-player.velocity.z, -player.velocity.x)
			var target_quat:Quaternion = Quaternion.from_euler((Vector3(0, dir.angle(), 0)))
			player.mesh.quaternion = player.mesh.quaternion.slerp(target_quat, delta * 10)
			
		if player.path.progress == 0:
			player.velocity = Vector3(0, 0, 0)
			state_machine.change_state("Idle")
			player.is_back = false
			if player.get_scene() and player.get_scene().PostEffect_CRT :
				player.get_scene().PostEffect_CRT.hide()
		
