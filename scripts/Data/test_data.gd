extends Node

# 结算事件
signal ITEM_COMMIT(level_index:int, item_enum:int)
signal BLOCK_COMMIT(level_index:int, block_enum:int)

func _ready() -> void:
	print("ccccc")
	emit_signal("ITEM_COMMIT", 2, 3)

var timer = 0
var total_time = 5 # 5s
func _process(delta: float) -> void:
	if total_time <= 0:
		return

	timer += delta	
	if timer > 1 :
		timer -= 1
		total_time -= 1
		print(total_time)
