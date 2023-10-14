extends ColorRect

@onready var soulsText = $Label
@onready var timerText = $Label2
@onready var player = get_tree().get_root().get_node("MainScene/Player")
@onready var timer = get_tree().get_root().get_node("MainScene/Player/GhostTimer") 

func _process(_delta):
	soulsText.text = ("Souls: " + str(player.total_souls) + " / " + str(player.cur_souls))
	timerText.text = ("Time: " + str(snapped(timer.time_left, 0.1)) + " s")
