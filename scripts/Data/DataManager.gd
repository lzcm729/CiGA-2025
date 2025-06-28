extends Node
# 全局的单例数据管理

# 依赖项
var data_config = load("res://scripts/Data/Data.gd")

# 数据管理对象
var cur_scene_id = Consts.SCENES.START_UP
var current_level = 0

var achievement = {}

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
	#if cur_scene_id != Consts.SCENES.LEVEL_SELECT:
		#print("Not In Level Select")
		#return
	current_level = target_level

func handle_item_signal(level_index:int, item_enum:int) -> void:
	print(level_index, item_enum)
	if achievement[level_index] == null:
		achievement[level_index] = {"level" : false, "item":{}, "block":{}}
	achievement[level_index]["item"][item_enum] = true

func handle_block_signal(level_index:int, block_enum:int) -> void:
	print(level_index, block_enum)
	if achievement[level_index] == null:
		achievement[level_index] = {"level" : false, "item":{}, "block":{}}
	achievement[level_index]["block"][block_enum] = true

func handle_level_success(level_index:int) -> void:
	print(level_index)
	if achievement[level_index] == null:
		achievement[level_index] = {"level" : false, "item":{}, "block":{}}
	achievement[level_index]["level"] = true

func get_cur_level_config() ->Array:
	if current_level == 0:
		return [current_level, {}]
	else:
		return [current_level, data_config.LEVEL_INFO[current_level]]

func _ready() -> void:
	print("hello world")
	#print(data_config.LEVEL_INFO[1])
	#switch_scene(Consts.SCENES.START_UP)
	
	# 数据信号量处理
	#var target = get_node("/root/test")
	#target.connect("ITEM_COMMIT", handle_item_signal)
