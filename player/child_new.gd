extends Player

# 用于跟踪level3和level4中的状态
var has_entered_area_once = false

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
	
	# 在level3和level4场景中显示被子
	_show_quilt_for_level3_and_level4()

func _show_quilt_for_level3_and_level4() -> void:
	var current_level = DataManager.get_cur_level_config()[0]
	if current_level == 3 or current_level == 4:
		var quilt = get_node_or_null("被子 烘焙")
		if quilt:
			quilt.visible = true
			print("在关卡", current_level, "中显示被子")
		else:
			print("未找到被子对象")
	else:
		# 在其他关卡中隐藏被子
		var quilt = get_node_or_null("被子 烘焙")
		if quilt:
			quilt.visible = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	_handle_area_entered(body)

func _on_area_3d_area_entered(area: Area3D) -> void:
	_handle_area_entered(area)

func _handle_area_entered(node: Node) -> void:
	# 检查是否是book或watcher对象
	if not _is_book_or_watch(node):
		return
	
	var current_level = DataManager.get_cur_level_config()[0]
	
	if current_level == 3 or current_level == 4:
		# level3和level4的特殊逻辑
		if not has_entered_area_once:
			# 第一次进入area
			print("第一次进入area - 移除被子并禁用进入物体的移动")
			_remove_quilt()
			_disable_entering_object_movement(node)
			has_entered_area_once = true
		else:
			# 第二次进入area - 触发胜利
			print("第二次进入area - 触发胜利")
			_trigger_victory()
	else:
		# 其他关卡 - 直接触发胜利
		print("非level3/4关卡 - 直接触发胜利")
		_trigger_victory()

func _remove_quilt() -> void:
	var quilt = get_node_or_null("被子 烘焙")
	if quilt:
		quilt.queue_free()
		print("被子已移除")

func _disable_entering_object_movement(node: Node) -> void:
	# 查找进入area的物体（book或watcher）
	var target_object = _find_book_or_watcher_object(node)
	if target_object:
		# 检查是否是Player类型（CharacterBody3D的子类）
		if target_object.has_method("is_input_valid"):
			target_object.is_finished = true
			print("已禁用物体移动:", target_object.name)
		else:
			print("找到物体但不是Player类型:", target_object.name)
	else:
		print("未找到可禁用的物体")

func _find_book_or_watcher_object(node: Node) -> Node:
	# 检查当前节点是否是book或watcher
	if _is_book_or_watch(node):
		return node
	
	# 检查父节点
	var parent = node.get_parent()
	if parent and parent != self:
		return _find_book_or_watcher_object(parent)
	
	return null

func _trigger_victory() -> void:
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
	
	# 播放音效
	_play_turn_sound()

func _play_turn_sound() -> void:
	# 查找音效节点
	var sound_node = get_node_or_null("Sound")
	if sound_node and sound_node is AudioStreamPlayer3D:
		sound_node.play()
		print("播放转身音效")
	elif sound_node and sound_node is AudioStreamPlayer:
		sound_node.play()
		print("播放转身音效")
	else:
		print("未找到音效节点")

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
