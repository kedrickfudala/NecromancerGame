extends Sprite2D

@onready var animation : int = 0

func _process(_delta):
	animation += 1
	if animation == 3:
		animation = 0
		if frame < hframes - 1:
			frame += 1
		else:
			frame = 0
