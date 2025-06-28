extends Node3D
class_name MainScene
@onready var PostEffect_CRT: CanvasLayer = $CanvasLayer_CRT

var currentLevelIndex = 1
var levels = [] as Array[Level]
func switch_level(index:int) ->void:
	# 添加新场景到场景树
	for level in levels :
		if level.Index == index:
			add_child(level)
			level.scene = self
		else:
			remove_child(level)


func _ready() -> void:
	for level in get_tree().get_nodes_in_group("LevelGroup"):
		remove_child(level)
		levels.append(level)
	PostEffect_CRT.hide()
	currentLevelIndex = DataManager.get_cur_level_config()[0]	
	print('bbbbbbbbbbb',currentLevelIndex)	
	switch_level(currentLevelIndex)
	
