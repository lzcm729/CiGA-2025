extends Label
@onready var timer: Timer = $"../Timer"

func change_num(num):
	if num == 0:
		self.text = "开始"
		self.timer.start()
	else :
		self.visible = true
		self.text = str(num)
	
func _on_timer_timeout() -> void:
	self.visible = false
