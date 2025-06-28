extends Node

func _ready() -> void:
	print("Hello world222222!")
	DataManager.switch_scene(Consts.SCENES.START_UP)
