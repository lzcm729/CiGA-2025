extends Node3D
@onready var switch: MeshInstance3D = $Switch
@onready var light: MeshInstance3D = $Light
@onready var open_gap: Timer = $OpenGap
@onready var area_3d: Area3D = $Area3D


func _ready() -> void:
	change_lamp_state(true)
	
	
	
func _process(delta: float) -> void:
	pass


func change_lamp_state(is_open:bool):
	light.visible = is_open
	area_3d.visible = is_open
	if is_open:
		switch.position.z = -0.2
	else:
		switch.position.z = -0.3
		


func _on_open_gap_timeout() -> void:
	return
	var cur_visible = light.visible
	change_lamp_state(not(cur_visible))


func _on_area_3d_area_entered(area: Area3D) -> void:
	var is_test = area.is_in_group("test")
	if is_test:
		print("stop")
