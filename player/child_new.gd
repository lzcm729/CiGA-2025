extends Player

func _ready() -> void:
	super()
	# 连接 CHILD_COUNT_1_START 信号到 turn 函数
	var children = DataManager.get_cur_children()
	if children:
		children.CHILD_COUNT_1_START.connect(turn)
	
	# 连接Area3D的碰撞信号
	var area3d = get_node_or_null("Area3D")
	if area3d:
		area3d.body_entered.connect(_on_area_3d_body_entered)
		area3d.area_entered.connect(_on_area_3d_area_entered)

func _on_area_3d_body_entered(body: Node3D) -> void:
	_check_for_victory(body)

func _on_area_3d_area_entered(area: Area3D) -> void:
	_check_for_victory(area)

func _check_for_victory(node: Node) -> void:
	# 检查是否是book或watch对象
	if _is_book_or_watch(node):
		print("胜利！检测到目标对象：", node.name)
		# 触发胜利事件
		var gameplay = DataManager.get_cur_gameplay()
		if gameplay:
			gameplay.on_catch_child()

func _is_book_or_watch(node: Node) -> bool:
	# 检查节点名称是否包含book或watch
	var node_name = node.name.to_lower()
	if "Book" in node_name or "Watcher" in node_name:
		return true
	
	# 检查父节点
	var parent = node.get_parent()
	if parent and parent != self:
		return _is_book_or_watch(parent)
	
	return false

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
