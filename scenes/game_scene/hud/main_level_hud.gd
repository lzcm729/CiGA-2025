extends Control

@export var gameplay:GamePlay
@onready var count_down_num: Label = $CountDownMarginContainer/Control/Num
@onready var goal_panel: Panel = $GoalMarginContainer/Control/Panel
@onready var back: Button = $KeyMarginContainer/Control/Back



func _ready() -> void:
	gameplay.TIME_COUNTDOWN.connect(on_time_countdown)
	back.pressed.connect(on_back_pressed)

func on_time_countdown(cur_times:int):
	count_down_num.change_num(cur_times)

func show_guide_panel(is_show:bool):
	goal_panel.visible = is_show


func on_back_pressed():
	SceneLoader.load_scene("res://scenes/game_scene/select_level/select_level.tscn")
	
