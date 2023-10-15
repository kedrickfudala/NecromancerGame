extends Area2D

@onready var timer = $Timer
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_root().get_node("MainScene/Player") 
@onready var animation : int = 0

func _process(_delta):
	animation += 1
	if animation == 3:
		animation = 0
		if sprite.frame < sprite.hframes - 1:
			sprite.frame += 1
		else:
			sprite.frame = 0
	if timer.is_stopped(): queue_free()

func _on_area_entered(_area):
	if !player.alive:
		player.harvest_soul()
		#print(player.souls)
		queue_free()
