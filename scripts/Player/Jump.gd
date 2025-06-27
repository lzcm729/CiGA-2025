extends StateBase

@export var player: Player

func enter() -> void:
	super.enter()
	#print("enter jump")
	player.velocity.y = player.jump_velocity
	player.jump()
	

func exit() -> void:
	pass
	
func process_update(delta: float) -> void:
	pass
	
func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	if player.is_on_floor():
		state_machine.change_state("Idle")
	# # 下降
	# if player.velocity.y < 0:
	# 	state_machine.change_state("Fall")
	
	# 方向有值，说明在移动
	if player.direction:
		player.velocity.x = player.direction.x * player.speed
		player.velocity.z = player.direction.z * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	
	if abs(player.velocity.x) + abs(player.velocity.z) > 0.1:
		var characterDir = Vector2(player.velocity.z, player.velocity.x)
		var target_quaternion:Quaternion = Quaternion.from_euler(Vector3(0, characterDir.angle(), 0))
		player.mesh.quaternion = player.mesh.quaternion.slerp(target_quaternion, delta * 10)
