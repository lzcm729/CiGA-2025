extends Node3D
class_name Level
@onready var currentPlayerIndex : int = 1
@export var levelIndex : int = 0
var scene : MainScene
var is_current : bool = false

var playerList : Array[Player] = []

#关卡正在切换角色
var is_switching : bool = false

func find_player(index:int) -> Player:
	for player in playerList:
		if player.index == index :
			return player
	return null

func get_player_list() -> Array[Player]:
	return playerList

func switch_player(index:int) ->void:
	if index != currentPlayerIndex and !is_switching :
		var cur_player = find_player(currentPlayerIndex)
		var next_player = find_player(index)
		if cur_player and next_player :
			cur_player.pre_switch()
			cur_player.switch_camera_with_tween(next_player)

func make_play_list() -> void:
	var gameplay = DataManager.get_cur_gameplay()
	var children = DataManager.get_cur_children()
	if playerList.is_empty():
		for child in get_children():
			if child is Player:
				playerList.append(child)
				child.level = self
				gameplay.register_item_signal(child)
				children.register_item_signal(child)

func make_current(is_enable:bool) -> void:
	is_current = is_enable
	visible = is_enable
	print(name + ", is_current:" + str(is_current) + ", levelIndex:" + str(levelIndex))
	make_play_list()
	for child in playerList:
		child.make_current(child.index == currentPlayerIndex)

func _ready() -> void:
	make_current(true)
	
func _input(event: InputEvent) -> void:
	if is_current:
		var action = "switch"
		for player in playerList :
			if player.index != 0 :
				var playerIndex = action + str(player.index)
				if event.is_action_pressed(playerIndex) :
					switch_player(player.index)
