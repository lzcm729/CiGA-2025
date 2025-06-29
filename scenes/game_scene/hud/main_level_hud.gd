extends Control

@export var gameplay:GamePlay
@onready var count_down_num: Label = $CountDownMarginContainer/Control/Num
@onready var goal_panel: Panel = $GoalMarginContainer/Control/Panel
@onready var back: Button = $KeyMarginContainer/Control/Back
@onready var progress_bar: ProgressBar = $TimeMarginContainer/Control/ProgressBar
@onready var remain_time: Label = $TimeMarginContainer/Control/RemainTime

@onready var time_margin_container: MarginContainer = $TimeMarginContainer
@onready var progress_margin_container: MarginContainer = $ProgressMarginContainer
@onready var key_margin_container: MarginContainer = $KeyMarginContainer


var total_time:int

func _ready() -> void:
	var cur_level = DataManager.get_cur_level_config()[0]
	gameplay = get_node("/root/Level" + str(cur_level) + "/GamePlay")
	gameplay.TIME_COUNTDOWN.connect(on_time_countdown)
	back.pressed.connect(on_back_pressed)
	gameplay.GAME_START.connect(on_game_start)
	init_time_show()
	switch_hud_show(false)
	
func _process(delta: float) -> void:
	if not(total_time == 0):
		progress_bar.value = (gameplay.count_down_time_show/total_time) * 100
		remain_time.text = "%02d:%02d"%([(gameplay.count_down_time_show/60),(int(gameplay.count_down_time_show)%60)])

func on_time_countdown(cur_times:int):
	count_down_num.change_num(cur_times)

func show_guide_panel(is_show:bool):
	goal_panel.visible = is_show


func on_back_pressed():
	SceneLoader.load_scene("res://scenes/game_scene/select_level/select_level.tscn")
	
func on_game_start(input_time:int):
	total_time = input_time
	init_time_show()
	switch_hud_show(true)


func switch_hud_show(is_show):
	time_margin_container.visible = is_show
	progress_margin_container.visible = is_show
	key_margin_container.visible = is_show
	

func init_time_show():
	progress_bar.value = 100
	remain_time.text = "%02d:%02d"%([(total_time/60),(int(total_time)%60)])
