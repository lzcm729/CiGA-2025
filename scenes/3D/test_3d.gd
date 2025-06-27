extends Node3D
class_name Scene
@onready var currentIndex : int = 1

func find_player(index:int) -> Player:
	for player in get_tree().get_nodes_in_group("PlayerGroup"):
		if player is Player :
			if player.index == index :
				return player
	return null

func switch(index:int) ->void:
	if index != currentIndex :
		var cur_player = find_player(currentIndex)
		var next_player = find_player(index)
		if cur_player and next_player :
			cur_player.pre_switch()
			cur_player.switch_camera_with_tween(next_player)

func _input(event: InputEvent) -> void:
	var str = "switch"
	var oldIndex = currentIndex
	for i in range(1, 10, 1) :
		var playerIndex = str + str(i)
		if event.is_action_pressed(playerIndex) :
			switch(i)
