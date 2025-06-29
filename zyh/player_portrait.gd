extends Control
class_name PlayerPortrait
@onready var no_select: TextureRect = $NoSelect
@onready var select: TextureRect = $Select

func change_portrait_select_state(is_select:bool):
	select.visible = is_select
	no_select.visible = not(is_select)
