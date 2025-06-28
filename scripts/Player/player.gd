extends CharacterBody3D

class_name Player

var scene: Scene

@export var speed = 5.0
@export var back_speed = 15.0
@export var jump_velocity = 5
@export var index : int
@export var path : PathFollow3D
@export var enable_jump = false
@onready var mesh: Node3D = $Mesh
@onready var state_machine: StateMachine = $StateMachine
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D

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

func move() -> void:
	anim_state_machine.travel("Move")

func idle() -> void:
	anim_state_machine.travel("Idle")

func jump() -> void:
	anim_state_machine.travel("Jump")

## 下落动画播放
func fall() -> void:
	anim_state_machine.travel("Fall")

## 方向
var direction: Vector3

## 中立
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

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
	
	scene.add_child(temp_camera)
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
	camera_3d.current = false
	direction = Vector3(0, 0, 0)
	is_switching = true
	scene.is_switching = true

func post_switch() -> void :
	camera_3d.current = true
	is_switching = false
	scene.is_switching = false
	scene.currentIndex = index

func is_current_valid() -> bool :
	return scene.currentIndex == index

func is_input_valid() -> bool :
	return is_current_valid() and (not is_switching) and (not is_back)

func start_back() -> void :
	state_machine.change_state("Back")

func _ready() -> void:
	scene = get_tree().current_scene
	if path :
		path.progress_ratio = 0
		is_follow_path = true
		position.x = path.global_position.x
		position.z = path.global_position.z
		mesh.rotation.y = path.global_rotation.y + 180

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	if is_input_valid() :
		var input_dir : Vector2 
		if path :
			input_dir = Input.get_vector("move_left", "move_right", "move_down", "move_up")
			direction = Vector3(input_dir.y, 0, 0)
		else: 
			input_dir = Input.get_vector("move_left", "move_right", "move_down", "move_up")
			var rotation :Quaternion = Quaternion.from_euler(Vector3(0, spring_arm_3d.transform.basis.get_euler().y, 0))
			direction = (rotation * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
			
	move_and_slide()

func _input(event: InputEvent) -> void:
	if is_input_valid() :
		if enable_jump and event.is_action_pressed("jump") and is_on_floor():
			state_machine.change_state("Jump")
		if event.is_action_pressed("debug_back"):
			start_back()
			
