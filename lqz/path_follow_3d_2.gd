extends PathFollow3D

# PathFollowMover.gd  挂在 PathFollow2D 上
@export var speed : float    # 像素/秒
var length : float                   # 路径总长（像素）
  
func _ready():
	length = get_parent().curve.get_baked_length()
	set_process(false)      # start disabled

func _process(delta):
	progress_ratio += speed * delta / length
	if progress_ratio >= 1.0:
		progress_ratio = 0
		set_process(false)

func ShowOnce():
	progress_ratio = 0
	set_process(true)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("jump"):
		ShowOnce()
