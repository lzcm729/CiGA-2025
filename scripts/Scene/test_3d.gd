extends Node3D

@onready var currentIndex : int = 1
@export var PostEffect_CRT : CanvasLayer
var playerList : Array[Player] = []
var is_switching : bool = false
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func find_player(index:int) -> Player:
	for player in playerList:
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
	audio_stream_player_3d.play()
	for child in get_children():
		if child is Player:
			playerList.append(child)
	if PostEffect_CRT :
		PostEffect_CRT.hide()
	
func _input(event: InputEvent) -> void:
	if visible:
		var action = "switch"
		for player in playerList :
			var playerIndex = action + str(player.index)
			if event.is_action_pressed(playerIndex) :
				switch(player.index)
