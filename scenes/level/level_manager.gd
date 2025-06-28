extends Node

@export var gameplay:GamePlay

func _ready() -> void:
	DataManager.select_level(1)
	if gameplay:
		gameplay.count_down_and_start_game()
