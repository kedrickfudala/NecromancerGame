extends ColorRect

@onready var soulsText = $Label
@onready var timerText = $Label2
@onready var sprite = $soulsSprite
@onready var player = get_tree().get_root().get_node("MainScene/Player")

@onready var timer = get_tree().get_root().get_node("MainScene/Player/GhostTimer") 
@onready var animation : int = 0

func _process(_delta):
	soulsText.text = ("Souls: " + str(player.total_souls))
	timerText.text = ("Time: " + str(snapped(timer.time_left, 0.1)) + " s")
	
	animation += 1
	if animation == 3:
		animation = 0
		if sprite.frame < sprite.hframes - 1:
			sprite.frame += 1
		else:
			sprite.frame = 0
