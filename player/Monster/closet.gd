extends Player

const MAX_ANGLE := -45.0
const ROT_SPEED := 30.0  # 度/秒

var start_remove := false
var removing := false

@onready var toy = $Path3D/PathFollow3D/Doll
@onready var closet:    MeshInstance3D = $"Mesh/柜子"
@onready var door_pivot: Node3D       = $Mesh/Left
@onready var door_sound: AudioStreamPlayer3D = $Sound


# 缓慢打开门到指定角度（度），用时 duration 秒
func open_door_slow(angle_deg: float, duration: float) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(door_pivot, "rotation_degrees:y", angle_deg, duration)
	tween.tween_callback(remove_toy)
	door_sound.play()	
	

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


func remove_toy() -> void:
	var mover = toy.get_parent() as PathFollow3D
	var close_speed = 3.0
	var duration = mover.progress / close_speed    # 距离／速度 = 时间
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(mover, "progress", 0.0, duration)
	tween.tween_callback(func():
		toy.queue_free()
	)


func _process(delta):
	if Input.is_action_pressed("interact"):  # 默认是空格，或自己在项目设置里映射一个动作
		# 启动音效（按下时只播一次）
		if door_sound.playing == false:
			door_sound.play()
		# 持续往目标角度靠
		var y = door_pivot.rotation_degrees.y
		y = max(y - ROT_SPEED * delta, MAX_ANGLE)
		door_pivot.rotation_degrees.y = y
		# 到位后开始移除玩具
		if y <= MAX_ANGLE and not removing:
			removing = true
			remove_toy()
	else:
		# 松开键后只要不再按就不会再转
		door_sound.stop()
