extends Control
@onready var stamp: TextureRect = $Stamp
@onready var outline: TextureRect = $Outline

func change_state(is_finished:bool):
	stamp.visible = is_finished
