extends Node

# 关卡外部加载数据
const LEVEL_MAX = 3
const LEVEL_INFO = {
	# 关卡对应的数据设置
	1 : { "node_name" : "level1", "total_time" : 30.0, "item_list" : [Consts.ITEMS.BOOK], "BLOCKS" : [Consts.BLOCKS.BEAR]},
	2 : { "node_name" : "level2", "total_time" : 30.0, "item_list" : [], "BLOCKS" : []},
	3 : { "node_name" : "level3", "total_time" : 30.0, "item_list" : [], "BLOCKS" : []},
}

# 场景数据
const SCENE_INFO = {
	Consts.SCENES.START_UP : {"scene_file" : "res://scenes/main_scene/test.tscn"},
	Consts.SCENES.LEVEL_SELECT : {"scene_file" : "res://scenes/main_scene/test2.tscn"},
	Consts.SCENES.SCENE : {"scene_file" : "ccc"},
	Consts.SCENES.ABOUT : {"scene_file" : "ddd"}
}
