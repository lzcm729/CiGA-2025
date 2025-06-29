extends Node
# 全局的单例数据管理

# 依赖项
var data_config = load("res://scripts/Data/Data.gd")

# 数据管理对象
var cur_scene_id = Consts.SCENES.START_UP
var current_level = 0

var achievements = {}
func new_achievement() -> Dictionary:
	var res = {"level" : false, "success_time":-1, "item":{}, "block":{}}
	for item_enum in range(Consts.ITEMS.BOOK, Consts.ITEMS.DRAW + 1):
		res["item"][item_enum] = false
	return res

func switch_scene(target_scene:int) -> void:
	if (target_scene > Consts.SCENES.ABOUT) or (target_scene < Consts.SCENES.START_UP) :
		print("error scene")
		return	

	if (target_scene == cur_scene_id):
		print("already in scene", current_level)
		return

	var scene_info = data_config.SCENE_INFO[target_scene]
	print(scene_info['scene_file'])
	cur_scene_id = target_scene
	get_tree().change_scene_to_file(scene_info['scene_file'])

func select_level(target_level:int) -> void:
	if last_level != current_level and target_level != current_level:
		last_level = current_level
	current_level = target_level
	#update_datamanager_listener()

func handle_item_signal(item_enum:int) -> void:
	var level_index = current_level
	print(level_index, item_enum)
	if not achievements.has(level_index):
		achievements[level_index] = new_achievement()
	achievements[level_index]["item"][item_enum] = true

func handle_block_signal(block_enum:int) -> void:
	var level_index = current_level
	print(level_index, block_enum)
	if not achievements.has(level_index):
		achievements[level_index] = new_achievement()
	achievements[level_index]["block"][block_enum] = true

func handle_level_success(past_time:float) -> void:
	var level_index = current_level
	print(level_index)
	if not achievements.has(level_index):
		achievements[level_index] = new_achievement()
	var achievement = achievements[level_index]
	if achievement["level"] != true:
		achievement["level"] = true
	var cur_suc_time = achievement["success_time"]
	if cur_suc_time == -1:
		achievement["success_time"] = past_time
	elif past_time < cur_suc_time:
		achievement["success_time"] = past_time

func get_cur_level_config() ->Array:
	if current_level == 0:
		return [current_level, {}]
	else:
		return [current_level, data_config.LEVEL_INFO[current_level]]
		
func get_cur_level_ach(target_level:int) -> Dictionary:
	if target_level == 0:
		return new_achievement()
	else:
		if not achievements.has(target_level):
			achievements[target_level] = new_achievement()
		return achievements[target_level]

var last_level = 0
var cur_game_play:GamePlay
var cur_children:Children
var cur_main_hud:MainLevelHUD
func update_datamanager_listener() -> void:
	cur_game_play = get_node("/root/Level" + str(current_level) + "/GamePlay")
	cur_children = get_node("/root/Level" + str(current_level) + "/Children")
	cur_main_hud = get_node("/root/Level" + str(current_level) + "/MainLevelHud")
	if not cur_game_play.GAME_SUCCESS.has_connections():
		cur_game_play.GAME_SUCCESS.connect(handle_level_success)
	if not cur_game_play.GAME_ITEM_ACHIEVEMENT.has_connections():
		cur_game_play.GAME_ITEM_ACHIEVEMENT.connect(handle_item_signal)

func get_cur_gameplay() -> GamePlay:
	return cur_game_play

func get_cur_children() -> Children:
	return cur_children
	
func get_cur_mainhud() -> MainLevelHUD:
	return cur_main_hud

func _ready() -> void:
	pass
