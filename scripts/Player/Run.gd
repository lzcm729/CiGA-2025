extends StateBase
@export var player: Player

func enter() -> void:
	super.enter()
	print("enter Run")
	player.is_moving = true
	

func exit() -> void:
	pass
	
func process_update(delta: float) -> void:
	pass
	
func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	if player.direction:
		player.velocity.x = player.direction.x * player.speed
		player.velocity.z = player.direction.z * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	
	if abs(player.velocity.x) + abs(player.velocity.z) > 0.1:
		var dir = Vector2(player.velocity.z, player.velocity.x)
		var target_quat:Quaternion = Quaternion.from_euler((Vector3(0, dir.angle(), 0)))
		player.mesh.quaternion = player.mesh.quaternion.slerp(target_quat, delta * 10)
		
	if player.direction == Vector3.ZERO:
		state_machine.change_state("Idle")
		
