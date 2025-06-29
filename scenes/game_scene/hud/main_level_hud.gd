extends Control

class_name MainLevelHUD

@export var gameplay:GamePlay
@onready var count_down_num: Label = $CountDownMarginContainer/Control/Num
@onready var goal_panel: Panel = $GoalMarginContainer/Control/Panel
@onready var back: Button = $KeyMarginContainer/Control/Back
@onready var progress_bar: ProgressBar = $TimeMarginContainer/Control/ProgressBar
@onready var remain_time: Label = $TimeMarginContainer/Control/RemainTime

@onready var time_margin_container: MarginContainer = $TimeMarginContainer
@onready var progress_margin_container: MarginContainer = $ProgressMarginContainer
@onready var key_margin_container: MarginContainer = $KeyMarginContainer
@onready var player_portrait: Control = $PlayerPortrait

##小孩子的倒计时
@onready var child_speak: Control = $ChildSpeak
@onready var child_speak_1: TextureRect = $"ChildSpeak/Num/1"
@onready var child_speak_2: TextureRect = $"ChildSpeak/Num/2"
@onready var child_speak_3: TextureRect = $"ChildSpeak/Num/3"

@onready var child_speak_scare_1: HBoxContainer = $ChildSpeak/Mark/Scare1
@onready var child_speak_scare_2: HBoxContainer = $ChildSpeak/Mark/Scare2
@onready var child_speak_scare_3: TextureRect = $ChildSpeak/Mark/Scare3

@onready var end_container: MarginContainer = $EndContainer
@onready var book: PlayerPortrait = $PlayerPortrait/HBoxContainer/Book
@onready var closet: PlayerPortrait = $PlayerPortrait/HBoxContainer/Closet
@onready var watcher: PlayerPortrait = $PlayerPortrait/HBoxContainer/Watcher
@onready var lamp: PlayerPortrait = $PlayerPortrait/HBoxContainer/Lamp

var total_time:int
var now_level:Level
var cur_level:int

func _ready() -> void:
	cur_level = DataManager.get_cur_level_config()[0]
	gameplay = get_node("/root/Level" + str(cur_level) + "/GamePlay")
	gameplay.TIME_COUNTDOWN.connect(on_time_countdown)
	back.pressed.connect(on_back_pressed)
	gameplay.GAME_START.connect(on_game_start)
	gameplay.GAME_SUCCESS.connect(on_game_success)
	init_time_show()
	switch_hud_show(false)
	end_container.visible = false
	show_guide_panel(true)
	var child = DataManager.get_cur_children()
	child.CHILD_COUNT_3.connect(on_child_count3_show)
	child.CHILD_COUNT_2.connect(on_child_count2_show)
	child.CHILD_COUNT_1_START.connect(on_child_count1_show)
	child.CHILD_COUNT_1_END.connect(on_child_count1_end)
	now_level = get_parent()
	change_player_portrait_show_by_level()

func register_switch_end(i:Player):
	i.switch_player_end.connect(update_player_portrait)

##初始化所有的小孩子说话显示
func init_child_speak():
	child_speak_1.visible = false
	child_speak_2.visible = false
	child_speak_3.visible = false
	child_speak_scare_1.visible = false
	child_speak_scare_2.visible = false
	child_speak_scare_3.visible = false

##1的显示
func show_child_count1():
	child_speak_1.visible = true


##2的显示
func show_child_count2():
	child_speak_2.visible = true
	
	
##3的显示
func show_child_count3():
	child_speak_3.visible = true
	

#scare1的显示
func show_child_speak_scare1():
	child_speak_scare_1.visible = true

#scare2的显示
func show_child_speak_scare2():
	child_speak_scare_2.visible = true

#scare3的显示
func show_child_speak_scare3():
	child_speak_scare_3.visible = true


func on_child_count3_show():
	init_child_speak()
	show_child_count3()

func on_child_count2_show():
	init_child_speak()
	show_child_count2()

func on_child_count1_show():
	init_child_speak()
	show_child_count1()


func on_child_count1_end():
	init_child_speak()


func update_player_portrait():
	book.change_portrait_select_state(now_level.currentPlayerIndex==1)
	closet.change_portrait_select_state(now_level.currentPlayerIndex==2)
	watcher.change_portrait_select_state(now_level.currentPlayerIndex==3)
	lamp.change_portrait_select_state(now_level.currentPlayerIndex==4)


#根据当前的关卡显示对应的头像
func init_player_portrait():
	book.visible = false
	closet.visible = false
	watcher.visible = false
	lamp.visible = false

func change_player_portrait_show_by_level():
	init_player_portrait()
	if cur_level ==1:
		book.visible = true
	elif cur_level == 2:
		book.visible = true
		closet.visible = true
	elif cur_level == 3:
		book.visible = true
		closet.visible = true
		watcher.visible = true
	elif cur_level == 4:
		book.visible = true
		closet.visible = true
		watcher.visible = true
		lamp.visible = true

	
	
	
func _process(delta: float) -> void:
	if not(total_time == 0):
		progress_bar.value = (gameplay.count_down_time_show/total_time) * 100
		remain_time.text = "%02d:%02d"%([(gameplay.count_down_time_show/60),(int(gameplay.count_down_time_show)%60)])

func on_time_countdown(cur_times:int):
	show_guide_panel(false)
	count_down_num.change_num(cur_times)
	update_player_portrait()

func show_guide_panel(is_show:bool):
	goal_panel.visible = is_show


func on_back_pressed():
	SceneLoader.load_scene("res://scenes/game_scene/select_level/select_level.tscn")
	
func on_game_start(input_time:int):
	total_time = input_time
	init_time_show()
	switch_hud_show(true)
	end_container.visible = false


func switch_hud_show(is_show):
	time_margin_container.visible = is_show
	progress_margin_container.visible = is_show
	key_margin_container.visible = is_show
	player_portrait.visible = is_show
	

func init_time_show():
	progress_bar.value = 100
	remain_time.text = "%02d:%02d"%([(total_time/60),(int(total_time)%60)])

func on_game_success(past_time:float):
	switch_hud_show(false)
	end_container.visible=true	

func _on_back_pressed() -> void:
	SceneLoader.load_scene("res://scenes/game_scene/select_level/select_level.tscn")
