extends CSGPolygon3D

@onready var is_show : bool = false :
	set(value):
		is_show = value
		if is_show:
			show()
		else:
			hide()
			
func _ready() -> void:
	is_show = false
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_path"):
		is_show = true
	elif event.is_action_released("show_path"):
		is_show = false
