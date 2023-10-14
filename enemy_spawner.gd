extends StaticBody2D

@export var radius : int
@export var speed : int
@onready var timer = $Timer
@onready var x = 0
@onready var enemy_num: int = 0
@onready var vis: bool = false

@onready var player = get_tree().get_root().get_node("MainScene/Player")
@onready var enemy : PackedScene = preload("res://enemy_test.tscn")

func _process(delta):
	x += (speed * delta)
	global_position = Vector2(sin(x) * radius, cos(x) * radius)

	if timer.is_stopped(): 
		vis = (global_position.distance_to(player.global_position) < 1000)
		#print(str(global_position.distance_to(player.global_position)) + " " + str(vis))
		if enemy_num < 20 and !vis:
			var enemy_inst = enemy.instantiate()
			get_tree().current_scene.add_child(enemy_inst)
			enemy_inst.global_position = global_position #+ Vector2(-100, -25)
			enemy_inst.scale = Vector2(1, 1)
			enemy_num += 1
			#print(enemy_num)
		timer.start()
