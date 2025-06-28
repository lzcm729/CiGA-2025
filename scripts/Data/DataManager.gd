extends Node
# 全局的单例数据管理

# 依赖项
var data_config = load("res://scripts/Data/Data.gd")

# 数据管理对象
var cur_scene_id = Consts.SCENES.START_UP
var current_level = 1

func switch_scene(target_scene:int) -> void:
	if (target_scene > Consts.SCENES.ABOUT) or (target_scene < Consts.SCENES.START_UP) :
		print("error scene")
		return	
	var scene_info = data_config.SCENE_INFO[target_scene]
	print(scene_info['scene_file'])
	#get_tree().change_scene_to_file(scene_info['scene_file'])

func handle_item_signal(level_index:int, item_enum:int) -> void:
	print(level_index, item_enum)

func handle_block_signal(level_index:int, block_enum:int) -> void:
	print(level_index, block_enum)

func _ready() -> void:
	print("hello world")
	#print(data_config.LEVEL_INFO[1])
	#switch_scene(Consts.SCENES.START_UP)
	
	# 数据信号量处理
	var target = get_node("/root/test")
	target.connect("ITEM_COMMIT", handle_item_signal)
