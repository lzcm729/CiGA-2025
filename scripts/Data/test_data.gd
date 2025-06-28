extends Node

# 结算事件
signal ITEM_COMMIT(level_index:int, item_enum:int)
signal BLOCK_COMMIT(level_index:int, block_enum:int)

func _ready() -> void:
	print("ccccc")
	emit_signal("ITEM_COMMIT", 2, 3)
