extends Player

const MAX_ANGLE := -45.0
const ROT_SPEED := 25.0  # 度/秒

var opened := false
var be_seen := false
var is_eating := false

@onready var toy = $Path3D/PathFollow3D/Doll
@onready var closet:    MeshInstance3D = $"Mesh/柜子"
@onready var left_door: Node3D       = $Mesh/Left
@onready var door_sound: AudioStreamPlayer3D = $Sound


func _ready() -> void:
	pass
	# 1.5 秒内打开 45°
	#open_door_slow(-45.0, 3)
	
	
# func _process(delta: float) -> void:
# 	if not start_remove: return
# 	var mover = toy.get_parent() as PathFollow3D
# 	var length = mover.get_parent().curve.get_baked_length()
# 	var speed = 3.0
# 	mover.progress -= speed * delta
# 	if mover.progress <= 0:
# 		start_remove = false
# 		toy.queue_free()


func _process(delta):
	if not is_current: return
	if be_seen: return
	if opened: return  # 如果已经打开了，就不再处理
	if Input.is_action_pressed("interact"):  # 默认是空格，或自己在项目设置里映射一个动作
		# 启动音效（按下时只播一次）
		if door_sound.playing == false:
			door_sound.play()
		# 持续往目标角度靠
		var y = left_door.rotation_degrees.y
		y = max(y - ROT_SPEED * delta, MAX_ANGLE)
		left_door.rotation_degrees.y = y
		start_action.emit(Consts.ITEMS.CLOSET)
		# 到位后开始移除玩具
		if y <= MAX_ANGLE:
			remove_toy()
			opened = true
			finish_action.emit(Consts.ITEMS.CLOSET)
	else:
		# 松开键后只要不再按就不会再转
		door_sound.stop()
		stop_action.emit(Consts.ITEMS.CLOSET)
		
		
func start_back() -> void :
	if is_eating: return
	shut_door()
	stop_action.emit(Consts.ITEMS.CLOSET)
	be_seen = true


# 缓慢打开门到指定角度（度），用时 duration 秒
#func open_door_slow(angle_deg: float, duration: float) -> void:
	#var tween = create_tween()
	#tween.set_trans(Tween.TRANS_SINE)
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(left_door, "rotation_degrees:y", angle_deg, duration)
	#tween.tween_callback(remove_toy)
	#door_sound.play()	
	

func remove_toy() -> void:
	if not toy: return  # 如果玩具已经被移除，则不再执行
	is_eating = true
	var mover = toy.get_parent() as PathFollow3D
	var close_speed = 3.0
	var duration = mover.progress / close_speed    # 距离／速度 = 时间
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(mover, "progress", 0.0, duration)
	tween.tween_callback(func():
		toy.queue_free()
		shut_door()
	)


# 关闭门
func shut_door() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(left_door, "rotation_degrees:y", 0.0, 0.1)
	tween.tween_callback(func():
		be_seen = false
	)
	door_sound.play()
