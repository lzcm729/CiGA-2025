extends Node

var timer = 0
@export var count_down = -1
@export var count_down_time_show = -1

signal GAME_START(total_time)
signal GAME_TIMEOUT()

func game_start(total_time:float) -> void:
	if count_down >= 0:
		return
	count_down = total_time
	emit_signal("GAME_START", total_time)

func _process(delta: float) -> void:
	if (count_down <= 0) : 
		return
	
	timer += delta
	count_down_time_show -= delta
	if (timer >= 1):
		timer -= 1
		count_down -= 1
		if (count_down <= 0):
			emit_signal("GAME_TIMEOUT")

@onready var time: Timer = $"../Timer"
func on_timer_end() -> void:
	game_start(30.0)
	print("Change Scene")
	DataManager.switch_scene(Consts.SCENES.LEVEL_SELECT)

func _ready() -> void:
	return
	#time.connect("timeout", on_timer_end)
	#time.start(5)
