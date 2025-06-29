extends StateBase
@export var player: Player

func enter() -> void:
	super.enter()
	#print("enter Teun")
	player.idle()
	

func exit() -> void:
	pass
	
func process_update(delta: float) -> void:
	pass
	
func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
