extends Node3D
class_name MainScene
@onready var PostEffect_CRT: CanvasLayer = $CanvasLayer_CRT

var currentLevelIndex = 2
var levels = [] as Array[Level]
func switch_level(index:int) ->void:
	# 添加新场景到场景树
	for level in levels :
		if level.Index == index:
			add_child(level)
			level.scene = self
		else:
			if self.is_ancestor_of(level):
				remove_child(level)


func _ready() -> void:
	for level in get_tree().get_nodes_in_group("LevelGroup"):
		if self.is_ancestor_of(level):
			remove_child(level)
			levels.append(level)
	PostEffect_CRT.hide()		
	switch_level(currentLevelIndex)
	
