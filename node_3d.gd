extends Node3D

@onready var toy = $Path3D/PathFollow3D/MeshInstance3D

var start_remove := false

@onready var closet:    MeshInstance3D = $"衣柜"
@onready var door_pivot: Node3D       = $"柜门"
@onready var door_sound: AudioStreamPlayer3D = $DoorSound


# 缓慢打开门到指定角度（度），用时 duration 秒
func open_door_slow(angle_deg: float, duration: float) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(door_pivot, "rotation_degrees:y", angle_deg, duration)
	tween.tween_callback(remove_toy)
	door_sound.play()	
	

func _ready() -> void:
	# 1.5 秒内打开 45°
	open_door_slow(-45.0, 3)
	
	
func _process(delta: float) -> void:
	if not start_remove: return
	var mover = toy.get_parent() as PathFollow3D
	var length = mover.get_parent().curve.get_baked_length()
	var speed = 3.0
	mover.progress -= speed * delta
	if mover.progress <= 0:
		start_remove = false
		toy.queue_free()


func remove_toy() -> void:
	start_remove = true
