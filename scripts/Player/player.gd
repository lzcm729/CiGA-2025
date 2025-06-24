extends CharacterBody3D

class_name Player

@export var speed = 5.0
@export var jump_velocity = 5

@onready var mesh: Node3D = $Mesh
@onready var state_machine: StateMachine = $StateMachine
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

@onready var is_moving : bool = false :
	set(value):
		is_moving = value
		if is_moving:
			anim_state_machine.travel("Move")
		else:
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

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var input_dir := Input.get_vector("move_left", "move_right", "move_down", "move_up")
	var rotation :Quaternion = Quaternion.from_euler(Vector3(0, spring_arm_3d.transform.basis.get_euler().y, 0))
	direction = (rotation * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		state_machine.change_state("Jump")
