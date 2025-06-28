extends PathFollow3D

# PathFollowMover.gd  挂在 PathFollow2D 上
@export var speed : float    # 像素/秒
var length : float                   # 路径总长（像素）
  
func _ready():
	length = get_parent().curve.get_baked_length()

func _process(delta):
	progress_ratio += speed * delta / length   # progress ∈ [0,1]
	if progress_ratio > 1.0:
		queue_free()  # 跑完自动删除；或 progress = 0 循环
