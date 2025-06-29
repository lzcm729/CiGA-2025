extends Player
class_name Draw


@export var lamp : Lamp
var is_finished := false


func _process(delta: float) -> void:
	if is_finished: return
	if lamp.is_relighting: return
	if Input.is_action_pressed("interact"):
		var res = lamp.decrease_light(delta)
		if res:
			start_action.emit(Consts.ITEMS.DRAW)
		else:
			finish_action.emit(Consts.ITEMS.DRAW)
			is_finished = true
	else:
		lamp.increase_light(delta)
		stop_action.emit(Consts.ITEMS.DRAW)


func start_back() -> void :
	lamp.Relight()
	stop_action.emit(Consts.ITEMS.DRAW)
