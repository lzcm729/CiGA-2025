extends Player

func _ready() -> void:
	super()
	# 连接 CHILD_COUNT_1_START 信号到 turn 函数
	var children = DataManager.get_cur_children()
	if children:
		children.CHILD_COUNT_1_START.connect(turn)

func turn() -> void:
	if anim_state_machine:
		anim_state_machine.travel("Turn")

		var timer1 = Timer.new()
		add_child(timer1)
		timer1.wait_time = 3  # 暂停2秒
		timer1.one_shot = true
		timer1.timeout.connect(func():
			idle()
		)
		timer1.start()
#
		## 创建定时器，延迟恢复动画
		#var timer2 = Timer.new()
		#add_child(timer2)
		#timer2.wait_time = 3.0  # 暂停2秒
		#timer2.one_shot = true
		#timer2.timeout.connect(func():
			#animation_tree.active = true
			#timer2.queue_free()
		#)
		#timer2.start()

func move() -> void:
	pass

func jump() -> void:
	pass

## 下落动画播放
func fall() -> void:
	pass

func _physics_process(delta: float) -> void: 
	super._physics_process(delta)
	pass
