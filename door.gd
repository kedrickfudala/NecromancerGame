extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var player = get_tree().get_root().get_node("MainScene/Player")
@onready var animation : int = 0

func _ready():
	sprite.frame = 8
	
func _process(_delta):
	animation += 1
	if animation == 3:
		animation = 0
		if player.total_souls < player.soul_goal:
			if sprite.frame == 15:
				sprite.frame = 8
		else:
			if sprite.frame == 22:
				sprite.frame = 16
		sprite.frame += 1
	
	if global_position.distance_to(player.global_position) < player.soul_goal and player.total_souls >= 10 and player.alive:
		print("You win!")
		get_tree().paused = true
