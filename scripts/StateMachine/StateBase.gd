extends Node3D

class_name StateBase

var state_machine: StateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func process_update(delta: float) -> void:
	pass
	
func physics_process_update(delta: float) -> void:
	pass
