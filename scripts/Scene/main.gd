extends Node3D
class_name MainScene
@onready var PostEffect_CRT: CanvasLayer = $CanvasLayer_CRT
@onready var PostEffect_EdgeChange: CanvasLayer = $CanvasLayer_EdgeChange

var currentLevelIndex = 2
var levels : Array[Level] = []
func switch_level(index:int) ->void:
	# 添加新场景到场景树
	for level in levels :
		if level.levelIndex == index:
			if not is_ancestor_of(level):
				add_child(level)
			level.make_current(true)
		else:
			if is_ancestor_of(level):
				remove_child(level)
			level.make_current(false)

func _ready() -> void:
	for level in get_children():
		if level is Level:
			levels.append(level)
			level.scene = self
			print("level:")
			print(level.name)
			print(level.levelIndex)
	PostEffect_CRT.hide()		
	PostEffect_EdgeChange.hide()
	currentLevelIndex = DataManager.get_cur_level_config()[0]	
	switch_level(currentLevelIndex)
