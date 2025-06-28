extends Node
class_name GamePlay

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
	var cur_level_info = DataManager.get_cur_level_config()
	game_start(cur_level_info[1]["total_time"])


func count_down_and_start_game() -> void:
	time.connect("timeout", on_timer_end)
	time.start(5)
	var cur_level_info = DataManager.get_cur_level_config()
	var main_node = get_parent()
	main_node.switch_level(cur_level_info[0])

func _ready() -> void:
	return
