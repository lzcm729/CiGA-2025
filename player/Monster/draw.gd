extends Player
class_name Draw


@export var lamp : Lamp


func _process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		lamp.decrease_light(delta)
	else:
		lamp.increase_light(delta)
