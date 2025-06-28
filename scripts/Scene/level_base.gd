extends Node3D
class_name Level
@onready var currentPlayerIndex : int = 1
@export var Index : int = 0
var scene : MainScene
var playNum : int = 0

#关卡正在切换角色
var is_switching : bool = false

func find_player(index:int) -> Player:
	for player in get_tree().get_nodes_in_group("PlayerGroup"):
		if player is Player :
			if player.index == index :
				return player
	return null

func switch_player(index:int) ->void:
	if index != currentPlayerIndex and !is_switching :
		var cur_player = find_player(currentPlayerIndex)
		var next_player = find_player(index)
		if cur_player and next_player :
			cur_player.pre_switch()
			cur_player.switch_camera_with_tween(next_player)

func _ready() -> void:
	playNum = 1
	for player in get_tree().get_nodes_in_group("PlayerGroup"):
		if player is Player :
			playNum += 1
	
func _input(event: InputEvent) -> void:
	if visible:
		var action = "switch"
		for i in range(1, playNum, 1) :
			var playerIndex = action + str(i)
			if event.is_action_pressed(playerIndex) :
				switch_player(i)
