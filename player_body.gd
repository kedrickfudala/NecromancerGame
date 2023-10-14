extends Area2D

@onready var sprite = $Sprite2D
@onready var animation : int = 0
@export var souls_needed : int = 2

@onready var player = get_tree().get_root().get_node("MainScene/Player") 

func _process(_delta):
	if global_position.y > player.global_position.y:
		z_index = player.z_index + 1
	else:
		z_index = player.z_index - 1
		
	animation += 1
	if animation == 3:
		animation = 0
		if sprite.frame < sprite.hframes - 1:
			sprite.frame += 1
		else:
			sprite.frame = 0

func _on_area_entered(_area):
	if player.cur_souls >= souls_needed:
		player.resurrect()
		queue_free()
