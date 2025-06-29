extends Node

class_name Children

@onready var PostEffect_EdgeChange: CanvasLayer = $"../CanvasLayer_EdgeChange"
@onready var PostEffect_CRT: CanvasLayer = $"../CanvasLayer_CRT"
@onready var timer: Timer = $"../Timer"

const STATE_0 = 0 # 从 没有到 开始数 3
const STATE_3 = 1 # 从 数3 到 数2
const STATE_2 = 2 # 从 数2 到 数1 -> 等于结束
const STATE_1 = 3 # 从 数1 的 hold
const STATE_CATCH = 4 # 从被抓 到 回到原点

var cur_state = 0
var state_map = {
	STATE_0 : STATE_3,
	STATE_3 : STATE_2,
	STATE_2 : STATE_1,
	STATE_1 : STATE_0,
	STATE_CATCH : STATE_3,
}

signal CHILD_COUNT_3()
signal CHILD_COUNT_2()
signal CHILD_COUNT_1_START()
signal CHILD_COUNT_1_END()
signal CHILD_CATCH_YOU()

# 数据格式 ： {无 -> 3, 3 -> 2, 2 -> 1, 1 hold 时长}
# 趣味性上 可以是以下几种的随机组合 可以以固定的 5s 作为一组来设计差分
# 以人的反应来说 建议可以以 0.5 - 1s 作为检查节点 即 最少间隔为 0.5s
var cur_rule = 0
var tolerate = 0.5 # 回头状态下的容忍度
var state_rule = {
	1 : [3, 2, 0.5, 3],
	2 : [2, 2, 1, 3],
	3 : [1, 1.5, 2, 3]
}
const RULE_COUNT = 3

var total_time = 0.0
var last_past_time = 0.0
func child_on_game_start(input_time:float):
	total_time = input_time
	print("child listen game start", input_time)

var is_key_pressed = false
var key_press_time = 0.0
func _process(delta: float) -> void:
	if total_time <= 0:
		return
	
	if cur_rule == 0:
		cur_rule = randi_range(1, RULE_COUNT)
		cur_state = STATE_0
	
	var rule = state_rule[cur_rule]

	total_time -= delta
	last_past_time += delta

	# 回退状态下不再处理状态变化 直到回退状态结束
	if cur_state == STATE_CATCH:
		return

	var cur_time_target = rule[cur_state]

	# 回头状态下 开始检测玩家是否按键：
	if cur_state == STATE_1:
		# 处理按键状态
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
			# 新按前进键的时候 只要按键了 就被抓了
			if (not is_key_pressed):
				# 直接抓住
				print("孩子看到你了 你被抓住了")
				key_press_time = 0.0
				cur_state = STATE_CATCH
				last_past_time = 0.0

				var level:Level = get_parent()
				var cur_player = level.find_player(level.currentPlayerIndex)			
				cur_player.start_back()
				PostEffect_CRT.show()
				cur_player.is_catch = true

				emit_signal("CHILD_CATCH_YOU")
			else:
				# 之前就按着的话 累加按键时间
				print("孩子还没发现你 快跑")
				key_press_time += delta
		else:
			if is_key_pressed and key_press_time < tolerate:
				print("你及时停止了运动 逃过一劫")
			is_key_pressed = false
			key_press_time = 0.0
		
		# 检查按键时长
		if key_press_time >= tolerate:
			print("孩子看到你了 你被抓住了")
			key_press_time = 0.0
			cur_state = STATE_CATCH
			last_past_time = 0.0
			is_key_pressed = false	

			var level:Level = get_parent()
			var cur_player = level.find_player(level.currentPlayerIndex)			
			cur_player.start_back()
			PostEffect_CRT.show()
			cur_player.is_catch = true

			emit_signal("CHILD_CATCH_YOU")
			return

	# 处理下一个状态
	if last_past_time >= cur_time_target:
		# 一个状态的结束 切换到下一个状态并作上一个状态的结算
		match cur_state:
			STATE_0:
				is_key_pressed = false
				print("COUNT 3")
				emit_signal("CHILD_COUNT_3")
			STATE_3:
				print("COUNT 2")
				emit_signal("CHILD_COUNT_2")
			STATE_2:
				print("COUNT 1 - 并回头")
				PostEffect_EdgeChange.show()
				emit_signal("CHILD_COUNT_1_START")
				# 需要预处理玩家的按键状态
				if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
					is_key_pressed = true
					key_press_time = 0.0
				else:
					is_key_pressed = false
					key_press_time = 0.0
			STATE_1:
				PostEffect_EdgeChange.hide()
				print("回头结束 等待下一轮计数")
				emit_signal("CHILD_COUNT_1_END")
		cur_state = state_map[cur_state]
		last_past_time -= cur_time_target

func on_item_lock() -> void:
	cur_rule = 0
	last_past_time = 0
	cur_state = STATE_0
	
	var level:Level = get_parent()
	var cur_player = level.find_player(level.currentPlayerIndex)
	PostEffect_EdgeChange.hide()
	cur_player.is_catch = false

	timer.stop()
	timer.disconnect("timeout", on_item_lock)

func on_item_back_end() -> void:
	# 回退到原点 开始下一轮
	PostEffect_CRT.hide()
	print("回退到原点 开始下一轮")
	var rule = state_rule[cur_rule]
	var cur_time_target = rule[STATE_1]
	
	timer.connect("timeout", on_item_lock)
	timer.start(cur_time_target - last_past_time)

func register_item_signal(item:Player) -> void:
	item.back_end.connect(on_item_back_end)	

func _ready() -> void:
	DataManager.update_datamanager_listener()
	var gameplay = DataManager.get_cur_gameplay()
	gameplay.connect("GAME_START", child_on_game_start)
	PostEffect_EdgeChange.hide()
	PostEffect_CRT.hide()
