extends Node3D
class_name Scene
@onready var currentIndex : int = 1
@export var PostEffect_CRT : CanvasLayer
var playNum : int = 0
var is_switching : bool = false

func find_player(index:int) -> Player:
	for player in get_tree().get_nodes_in_group("PlayerGroup"):
		if player is Player :
			if player.index == index :
				return player
	return null

func switch(index:int) ->void:
	if index != currentIndex and !is_switching :
		var cur_player = find_player(currentIndex)
		var next_player = find_player(index)
		if cur_player and next_player :
			cur_player.pre_switch()
			cur_player.switch_camera_with_tween(next_player)

func _ready() -> void:
	playNum = 1
	for player in get_tree().get_nodes_in_group("PlayerGroup"):
		if player is Player :
			playNum += 1
	if PostEffect_CRT :
		PostEffect_CRT.hide()
	
func _input(event: InputEvent) -> void:
	var action = "switch"
	for i in range(1, playNum, 1) :
		var playerIndex = action + str(i)
		if event.is_action_pressed(playerIndex) :
			switch(i)
