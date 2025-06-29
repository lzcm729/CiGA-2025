extends Player
class_name Draw


@export var lamp : Lamp
@export var move_speed: float = 1.0             # 移动速度
@export var min_y: float = -3.0                 # 最低允许下降的 y 坐标
@onready var mesh_node: Node3D = $"Mesh"       # 引用 Mesh 节点
@onready var mesh_instance: MeshInstance3D = $"Mesh/MeshInstance3D"  # 引用圆柱体
@onready var mesh_instance2: MeshInstance3D = $"Mesh/MeshInstance3D2"  # 引用球体
@onready var hand_node: Node3D = $"Mesh/手"    # 引用鬼手节点
@onready var init_y: float = $"Mesh/MeshInstance3D2".position.y  # 记录球体原始高度
@onready var init_scale: Vector3 = $"Mesh/MeshInstance3D".scale  # 记录圆柱体原始缩放
@onready var init_cylinder_y: float = $"Mesh/MeshInstance3D".position.y  # 记录圆柱体原始高度
@onready var init_hand_y: float = $"Mesh/手".position.y  # 记录鬼手原始高度
@onready var sound: AudioStreamPlayer3D = $Sound

#var is_finished := false

func _ready() -> void:
	super()
	# 检查MeshInstance3D是否正确引用
	if mesh_instance and mesh_instance2 and hand_node:
		print("=== 初始化信息 ===")
		print("MeshInstance3D 引用成功，初始缩放:", mesh_instance.scale)
		print("MeshInstance3D2 引用成功，初始位置:", mesh_instance2.position)
		print("鬼手节点引用成功，初始位置:", hand_node.position)
		print("圆柱体初始位置:", mesh_instance.position)
		print("球体初始位置:", mesh_instance2.position)
		print("圆柱体原始高度:", init_cylinder_y)
		print("球体原始高度:", init_y)
		print("鬼手原始高度:", init_hand_y)
		print("==================")
	else:
		print("错误：无法找到 MeshInstance3D、MeshInstance3D2 或鬼手节点")

	#lamp.draw = self

func _process(delta: float) -> void:
	if not is_current: return
	if is_finished: return
	if lamp.is_relighting: return

	if Input.is_action_pressed("move_up"):
		var res = lamp.decrease_light(delta)
		# ↓ 限制球体最低高度
		var dy = move_speed * delta
		var curr_y = mesh_instance2.position.y
		if curr_y - dy > min_y:
			# 移动球体和鬼手
			mesh_instance2.position.y -= dy
			if hand_node:
				hand_node.position.y -= dy
			# 圆柱体通过缩放匹配球体的移动
			var distance_moved = init_y - (curr_y - dy)
			var total_distance = init_y - min_y
			var scale_factor = distance_moved / total_distance
			var new_scale = 1.0 + scale_factor * 4.0  # 长度提升四倍
			if mesh_instance:
				# 设置圆柱体缩放
				mesh_instance.scale.y = new_scale
				# 设置圆柱体位置，使其中心位于球体和原始位置之间
				var cylinder_center_y = (mesh_instance2.position.y + init_y) / 2.0
				mesh_instance.position.y = cylinder_center_y
				print("=== 下降状态 ===")
				print("球体Y位置:", curr_y - dy)
				print("鬼手Y位置:", hand_node.position.y if hand_node else "N/A")
				print("移动距离:", distance_moved)
				print("缩放因子:", scale_factor)
				print("圆柱体缩放:", new_scale)
				print("圆柱体中心位置:", cylinder_center_y)
				print("==================")
		else:
			mesh_instance2.position.y = min_y
			if hand_node:
				hand_node.position.y = min_y + (init_hand_y - init_y)  # 保持鬼手相对于球体的位置
			if mesh_instance:
				mesh_instance.scale.y = 5.0  # 最大伸长，长度提升四倍
				var cylinder_center_y = (min_y + init_y) / 2.0
				mesh_instance.position.y = cylinder_center_y
				print("设置圆柱体最大缩放: 5.0, 中心位置:", cylinder_center_y)
		if res:
			start_action.emit(Consts.ITEMS.DRAW)
		else:
			finish_action.emit(Consts.ITEMS.DRAW)
			is_finished = true
	else:
		lamp.increase_light(delta)
		# ↑ 未按下时上升，但不超原位
		var rise = move_speed * delta
		var curr_y = mesh_instance2.position.y
		if curr_y + rise < init_y:
			# 移动球体和鬼手
			mesh_instance2.position.y += rise
			if hand_node:
				hand_node.position.y += rise
			# 恢复圆柱体缩放
			var distance_moved = init_y - (curr_y + rise)
			var total_distance = init_y - min_y
			var scale_factor = distance_moved / total_distance
			var new_scale = 1.0 + scale_factor * 4.0  # 长度提升四倍
			if mesh_instance:
				mesh_instance.scale.y = new_scale
				var cylinder_center_y = (mesh_instance2.position.y + init_y) / 2.0
				mesh_instance.position.y = cylinder_center_y
		else:
			mesh_instance2.position.y = init_y
			if hand_node:
				hand_node.position.y = init_hand_y  # 恢复鬼手原始位置
			if mesh_instance:
				mesh_instance.scale.y = 1.0  # 恢复原始缩放
				mesh_instance.position.y = init_cylinder_y  # 恢复原始位置
		stop_action.emit(Consts.ITEMS.DRAW)


func start_back() -> void :
	lamp.Relight()
	stop_action.emit(Consts.ITEMS.DRAW)
	
