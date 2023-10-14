extends Area2D

@onready var timer = $Timer
@onready var player = get_tree().get_root().get_node("MainScene/Player") 

func _process(delta):
	if timer.is_stopped(): queue_free()


func _on_area_entered(area):
	if !player.alive:
		player.souls += 1
		print(player.souls)
		queue_free()
