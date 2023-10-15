extends Area2D

@onready var sprite = $Sprite2D
@onready var animation : int = 0

func _process(_delta):
	animation += 1
	if animation == 3:
		animation = 0
		if sprite.frame < sprite.hframes - 1:
			sprite.frame += 1
		else:
			sprite.frame = 0
