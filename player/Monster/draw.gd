extends Player
class_name Draw


@export var lamp : Lamp
@export var move_speed: float = 1.0             # 移动速度
@export var min_y: float = -3.0                 # 最低允许下降的 y 坐标
@onready var mesh_node: Node3D = $"Mesh"       # 引用 Mesh 节点
@onready var init_y: float = $"Mesh".position.y  # 记录原始高度

var is_finished := false


func _process(delta: float) -> void:
	if not is_current: return
	if is_finished: return
	if lamp.is_relighting: return

	if Input.is_action_pressed("interact"):
		var res = lamp.decrease_light(delta)
		# ↓ 限制 Mesh 最低高度
		var dy = move_speed * delta
		var curr_y = mesh_node.position.y
		if curr_y - dy > min_y:
			mesh_node.translate(Vector3(0, -dy, 0))
		else:
			mesh_node.position.y = min_y
		if res:
			start_action.emit(Consts.ITEMS.DRAW)
		else:
			finish_action.emit(Consts.ITEMS.DRAW)
			is_finished = true
	else:
		lamp.increase_light(delta)
		# ↑ 未按下时上升，但不超原位
		var rise = move_speed * delta
		var curr_y = mesh_node.translation.y
		if curr_y + rise < init_y:
			mesh_node.translate(Vector3(0, rise, 0))
		else:
			mesh_node.translation.y = init_y
		stop_action.emit(Consts.ITEMS.DRAW)


func start_back() -> void :
	lamp.Relight()
	stop_action.emit(Consts.ITEMS.DRAW)
