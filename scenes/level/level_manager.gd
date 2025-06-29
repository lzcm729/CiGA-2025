extends Node

@export var gameplay:GamePlay
@export var main_level_hud:Control
@onready var start_count_down: Timer = $StartCountDown

func _ready() -> void:
	var cur_level = DataManager.get_cur_level_config()[0]
	start_count_down.start()
	main_level_hud = get_node("/root/Level" + str(cur_level) + "/MainLevelHud")
	start_count_down.timeout.connect(_on_start_count_down_timeout)
	gameplay = get_node("/root/Level" + str(cur_level) + "/GamePlay")


func _on_start_count_down_timeout() -> void:
	if gameplay:
		gameplay.count_down_and_start_game()
