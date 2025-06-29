extends Node
class_name GamePlay

var timer = 0
var past_time = 0
var game_is_finish = false
@export var count_down = -1
@export var count_down_time_show = -1

signal GAME_START(total_time:float)
signal GAME_TIMEOUT()
signal GAME_SUCCESS(past_time:float)
signal GAME_ITEM_ACHIEVEMENT(item_enum:int)

func game_start(total_time:float) -> void:
	if count_down >= 0:
		return
	game_is_finish = false
	past_time = 0
	count_down = total_time
	count_down_time_show = total_time
	emit_signal("GAME_START", total_time)

func _process(delta: float) -> void:
	if (count_down <= 0) : 
		return
	
	timer += delta
	count_down_time_show -= delta
	if !game_is_finish:
		past_time += delta

	if (timer >= 1):
		timer -= 1
		count_down -= 1
		if (count_down <= 0):
			emit_signal("GAME_TIMEOUT")

@onready var time: Timer = $"../Timer"
var times = 0
signal TIME_COUNTDOWN(cur_times)
func on_timer_end() -> void:
	emit_signal("TIME_COUNTDOWN", times)
	time.stop()
	var cur_level_info = DataManager.get_cur_level_config()
	game_start(cur_level_info[1]["total_time"])

func on_single_timer_end() -> void:
	emit_signal("TIME_COUNTDOWN", times)
	if times == 1:
		time.disconnect("timeout", on_single_timer_end)
		time.connect("timeout", on_timer_end)
		time.start(1)
	times -= 1

signal COUNTDOWN_5_START()
func count_down_and_start_game() -> void:
	times = 5
	time.connect("timeout", on_single_timer_end)
	time.start(1)
	emit_signal("COUNTDOWN_5_START")

func on_catch_child() -> void:
	game_is_finish = true
	emit_signal("GAME_SUCCESS", past_time)

func on_item_success(item_enum:int) -> void:
	emit_signal("GAME_ITEM_ACHIEVEMENT", item_enum)
	

func register_item_signal(item:Player) -> void:
	item.finish_action.connect(on_item_success)

func _ready() -> void:
	DataManager.update_datamanager_listener()
