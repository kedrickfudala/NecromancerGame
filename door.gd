extends Area2D

@onready var player = get_tree().get_root().get_node("MainScene/Player")

func _process(delta):
	if global_position.distance_to(player.global_position) < 100 and player.souls >= 10:
		print("You win!")
		get_tree().paused = true
