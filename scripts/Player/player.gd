extends CharacterBody3D

class_name Player

var level: Level
var animation_tree: AnimationTree
var state_machine: StateMachine
var anim_state_machine: AnimationNodeStateMachinePlayback

@export var speed = 5.0
@export var back_speed = 15.0
@export var jump_velocity = 5
@export var index : int
@export var path : PathFollow3D
@export var enable_jump = false
@export var ignore_gravity = false
@onready var mesh: Node3D = $Mesh
var spring_arm_3d: SpringArm3D
var camera_3d: Camera3D
 
#@onready var is_moving : bool = false :
	#set(value):
		#is_moving = value
		#if is_moving:
			#anim_state_machine.travel("Move")
		#else:
			#anim_state_machine.travel("Idle")

var is_switching : bool = false
var is_back : bool = false
var is_follow_path: bool = false
var is_current : bool = false

func move() -> void:
	if anim_state_machine:
		anim_state_machine.travel("Move")

func idle() -> void:
	if anim_state_machine:
		anim_state_machine.travel("Idle")

func jump() -> void:
	if anim_state_machine:
		anim_state_machine.travel("Jump")

## 下落动画播放
func fall() -> void:
	if anim_state_machine:
		anim_state_machine.travel("Fall")

## 方向
var direction: Vector3

## 中立
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_scene() -> MainScene:
	if level :
		return level.scene
	return null

func switch_camera_with_tween(next_player: Player) -> void :
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	var new_camera = next_player.camera_3d
	# 保存目标摄像机的属性
	var target_position = new_camera.global_transform.origin
	var target_rotation = new_camera.global_transform.basis.get_euler()
	var target_fov = new_camera.fov
	
	# 创建临时摄像机用于过渡
	var temp_camera = Camera3D.new()
	
	temp_camera.global_transform = camera_3d.global_transform
	temp_camera.fov = camera_3d.fov
	
	if get_scene():
		get_scene().add_child(temp_camera)
	else:
		level.add_child(temp_camera)
	temp_camera.current = true
	
	# 开始过渡动画
	tween.tween_property(temp_camera, "global_transform:origin", target_position, 1.0)
	tween.parallel().tween_property(temp_camera, "rotation", target_rotation, 1.0)
	tween.parallel().tween_property(temp_camera, "fov", target_fov, 1.0)
	
	# 动画完成后切换实际摄像机
	tween.tween_callback(func():
		temp_camera.current = false
		next_player.post_switch()
		temp_camera.queue_free()
	)

func pre_switch() -> void :
	make_current(false)
	direction = Vector3(0, 0, 0)
	is_switching = true
	level.is_switching = true
	idle()

func post_switch() -> void :
	make_current(true)
	is_switching = false
	level.is_switching = false
	level.currentPlayerIndex = index
	

func is_current_valid() -> bool :
	return is_current

func is_input_valid() -> bool :
	return visible and is_current_valid() and (not is_switching) and (not is_back)

func start_back() -> void :
	if state_machine:
		state_machine.change_state("Back")

func find_camera_3d() -> void:
	if !camera_3d:
		for child in get_children():
			if child is Camera3D:
				camera_3d = child
				return
			elif child is SpringArm3D:
				for child1 in child.get_children():
					if child1 is Camera3D:
						camera_3d = child1
						return

func make_current(is_enable:bool) -> void:
	find_camera_3d()
	if camera_3d:
		is_current = is_enable
		print("player make current:" + name + ", is_current:" + str(is_current))
		if is_enable:
			camera_3d.make_current()
		else:
			camera_3d.clear_current(false)
	else:
		is_current = false

func _ready() -> void:
	state_machine = get_node_or_null("/root/StateMachine")
	animation_tree = get_node_or_null("/root/AnimationTree")
	if animation_tree: 
		anim_state_machine = animation_tree.get("parameters/StateMachine/playback")
	spring_arm_3d = get_node_or_null("/root/SpringArm3D")
	find_camera_3d()
	if path :
		path.progress_ratio = 0
		is_follow_path = true
		position.x = path.global_position.x
		position.z = path.global_position.z
		mesh.rotation.y = path.global_rotation.y + 180

func _physics_process(delta: float) -> void:
	if not is_on_floor() && not ignore_gravity:
		velocity.y -= gravity * delta
	if is_input_valid() :
		var input_dir : Vector2 
		if path :
			input_dir = Input.get_vector("move_left", "move_right", "move_down", "move_up")
			direction = Vector3(input_dir.y, 0, 0)
		elif spring_arm_3d: 
			input_dir = Input.get_vector("move_left", "move_right", "move_down", "move_up")
			var rotation :Quaternion = Quaternion.from_euler(Vector3(0, spring_arm_3d.transform.basis.get_euler().y, 0))
			direction = (rotation * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if is_input_valid() :
		if enable_jump and event.is_action_pressed("jump") and is_on_floor():
			if state_machine:
				state_machine.change_state("Jump")
		if event.is_action_pressed("debug_back"):
			start_back()
			
