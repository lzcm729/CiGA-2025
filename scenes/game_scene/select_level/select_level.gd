extends Control
@onready var last: Button = $SwitchLevelMarginContainer/Control/Last
@onready var next: Button = $SwitchLevelMarginContainer/Control/Next
@onready var enter_game: Button = $EnterMarginContainer/Control/EnterGame
@onready var back: Button = $KeyMarginContainer/Control/Back
@onready var levels: Control = $Levels


@onready var level_1_sticker: Control = $EnterMarginContainer/Level1Sticker
@onready var level_2_sticker: Control = $EnterMarginContainer/Level2Sticker
@onready var level_3_sticker: Control = $EnterMarginContainer/Level3Sticker
@onready var level_4_sticker: Control = $EnterMarginContainer/Level4Sticker


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
	# 初始化时设置正确的sticker显示
	update_level_sticker_visibility()

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
		
	print(cur_select_index)
	
	# 更新sticker显示
	update_level_sticker_visibility()
	
	# 创建tween动画进行平滑旋转
	var tween = create_tween()
	tween.tween_property(levels, "rotation_degrees", levels.rotation_degrees + (-step*90), 0.5)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)

func update_sub_sticker_visible(node:Node):
	var cur_level_ach = DataManager.get_cur_level_ach()

	var book = node.find_child("Book")
	var closet = node.find_child("Closet")
	var watcher = node.find_child("Watcher")
	var lamp = node.find_child("Lamp")
	
	if book != null :
		book.find_child("Stamp").visible = cur_level_ach["item"][Consts.ITEMS.BOOK]
	
	if closet != null :
		closet.find_child("Stamp").visible = cur_level_ach["item"][Consts.ITEMS.CLOSET]

	#if watcher != null :
		#watcher.visible = cur_level_ach["item"][Consts.ITEMS.WATCHER]

	if lamp != null :
		lamp.find_child("Stamp").visible = cur_level_ach["item"][Consts.ITEMS.DRAW]

func update_level_sticker_visibility():
	# 隐藏所有sticker
	level_1_sticker.visible = false
	level_2_sticker.visible = false
	level_3_sticker.visible = false
	level_4_sticker.visible = false
	
	# 显示当前选中关卡对应的sticker
	match cur_select_index:
		1:
			level_1_sticker.visible = true
			update_sub_sticker_visible(level_1_sticker)
		2:
			level_2_sticker.visible = true
			update_sub_sticker_visible(level_2_sticker)
		3:
			level_3_sticker.visible = true
			update_sub_sticker_visible(level_3_sticker)
		4:
			level_4_sticker.visible = true
			update_sub_sticker_visible(level_4_sticker)

func on_enter_game_pressed():
	DataManager.select_level(cur_select_index)
	var level_info = DataManager.get_cur_level_config()
	SceneLoader.load_scene(level_info[1]["level_path"])

func on_back_pressed():
	SceneLoader.load_scene(back_path)
