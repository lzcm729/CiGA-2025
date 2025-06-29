extends Node

# 关卡外部加载数据
const LEVEL_MAX = 4
const LEVEL_INFO = {
	# 关卡对应的数据设置
	1 : { "node_name" : "level1", "level_path":"res://scenes/level/level1.tscn", "total_time" : 60.0, "item_list" : [Consts.ITEMS.BOOK], "BLOCKS" : [Consts.BLOCKS.BEAR]},
	2 : { "node_name" : "level2", "level_path":"res://scenes/level/level2.tscn", "total_time" : 120.0, "item_list" : [], "BLOCKS" : []},
	3 : { "node_name" : "level3", "level_path":"res://scenes/level/level3.tscn", "total_time" : 160.0, "item_list" : [], "BLOCKS" : []},
	4 : { "node_name" : "level4", "level_path":"res://scenes/level/level4.tscn", "total_time" : 200.0, "item_list" : [], "BLOCKS" : []},
}

# 场景数据
const SCENE_INFO = {
	Consts.SCENES.START_UP : {"scene_file" : "res://scenes/main_scene/test.tscn"},
	Consts.SCENES.LEVEL_SELECT : {"scene_file" : "res://scenes/main_scene/test2.tscn"},
	Consts.SCENES.SCENE : {"scene_file" : "ccc"},
	Consts.SCENES.ABOUT : {"scene_file" : "ddd"}
}
