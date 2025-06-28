extends Node3D

@onready var closet:    MeshInstance3D = $Closet
@onready var door_pivot: Node3D       = $Node3D
@onready var door_sound: AudioStreamPlayer3D = $DoorSound


# 缓慢打开门到指定角度（度），用时 duration 秒
func open_door_slow(angle_deg: float, duration: float) -> void:
	create_tween()\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)\
		.tween_property(door_pivot, "rotation_degrees:y", angle_deg, duration)
	door_sound.play()	
	

func _ready() -> void:
	# 1.5 秒内打开 45°
	open_door_slow(-45.0, 3)
