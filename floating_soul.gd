extends Node2D

@onready var sprite = $soulsSprite
@onready var animation : int = 0
@onready var num
@onready var player = get_tree().get_root().get_node("MainScene/Player")

func _ready():
	num = player.cur_souls - 1

func _process(_delta):
	global_position = player.global_position + Vector2(sin((player.x+(num*2*PI/player.cur_souls))) * 100, cos((player.x+(num*2*PI/player.cur_souls))) * 100)
	
	if player.cur_souls == 0:
		queue_free()
	
	animation += 1
	if animation == 3:
		animation = 0
		if sprite.frame < sprite.hframes - 1:
			sprite.frame += 1
		else:
			sprite.frame = 0
