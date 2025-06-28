extends Node

@export var gameplay:GamePlay
@export var main_level_hud:Control
@onready var start_count_down: Timer = $StartCountDown

func _ready() -> void:
	start_count_down.start()
	main_level_hud.show_guide_panel(true)
	start_count_down.timeout.connect(_on_start_count_down_timeout)


func _on_start_count_down_timeout() -> void:
	main_level_hud.show_guide_panel(false)
	if gameplay:
		gameplay.count_down_and_start_game()
