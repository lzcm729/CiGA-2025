extends StateBase
@export var player: Player

func enter() -> void:
	super.enter()
	#print("enter Run")
	player.move()
	

func exit() -> void:
	pass
	
func process_update(delta: float) -> void:
	pass
	
func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	if player.direction:
		if player.is_follow_path :
			var last_progress = player.path.progress
			var last_pos = Vector3(player.path.global_position.x, player.global_position.y, player.path.global_position.z)
			if player.ignore_gravity :
				last_pos.y = player.path.global_position.y
			player.path.progress = player.path.progress + player.direction.x * player.speed * 0.01
			var new_pos = Vector3(player.path.global_position.x, player.global_position.y, player.path.global_position.z)
			if player.ignore_gravity :
				new_pos.y = player.path.global_position.y
			player.velocity = (new_pos - last_pos) / delta
			
			var collision = player.move_and_collide(new_pos - last_pos, true)
			if collision and collision.get_collision_count() > 0 :
				for i in range(0, collision.get_collision_count(), 1) :
					var collider = collision.get_collider(i)	
					print("collider:" + collider.get_class().get_basename())
					if collider.is_class("StaticBody3D") :
						player.path.progress = last_progress
						player.velocity = Vector3.ZERO
						player.direction = Vector3.ZERO
						break
		else :
			player.velocity.x = player.direction.x * player.speed
			player.velocity.z = player.direction.z * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
		player.velocity.y = move_toward(player.velocity.y, 0, player.speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	
	if abs(player.velocity.x) + abs(player.velocity.z) > 0.1:
		var dir = Vector2(player.velocity.z, player.velocity.x)
		var target_quat:Quaternion = Quaternion.from_euler((Vector3(0, dir.angle(), 0)))
		player.mesh.quaternion = player.mesh.quaternion.slerp(target_quat, delta * 10)
		
	if player.direction == Vector3.ZERO:
		state_machine.change_state("Idle")
		
