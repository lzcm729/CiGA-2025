extends Control
@onready var last: Button = $SwitchLevelMarginContainer/Control/HBoxContainer/Last
@onready var next: Button = $SwitchLevelMarginContainer/Control/HBoxContainer/Next
@onready var label: Label = $EnterMarginContainer/Control/Panel/Label
@onready var enter_game: Button = $EnterMarginContainer/Control/EnterGame
@onready var back: Button = $KeyMarginContainer/Control/Back


@export_file("*.tscn") var back_path : String
@export_file("*.tscn") var level_path : String

var data_config = load("res://scripts/Data/Data.gd")
var cur_select_index = 1
var level_num:int

func _ready() -> void:
	level_num = data_config.LEVEL_MAX
	last.pressed.connect(on_last_pressed)
	next.pressed.connect(on_next_pressed)
	enter_game.pressed.connect(on_enter_game_pressed)
	back.pressed.connect(on_back_pressed)
	label.text = "当前关卡：" + str(cur_select_index)
	

func on_last_pressed():
	change_cur_select_level(-1)
	
func on_next_pressed():
	change_cur_select_level(1)
	
func change_cur_select_level(step:int):
	cur_select_index = cur_select_index + step
	if cur_select_index <= 0:
		cur_select_index += level_num
	elif cur_select_index > level_num:
		cur_select_index -= level_num
	label.text = "当前关卡：" + str(cur_select_index)
	
func on_enter_game_pressed():
	DataManager.select_level(cur_select_index)
	SceneLoader.load_scene(level_path)


func on_back_pressed():
	SceneLoader.load_scene(back_path)
