extends CharacterBody2D

@export var speed : int
@export var max_health : int = 100
@onready var cur_health : int = max_health
@onready var timer = $Timer

@onready var trail : PackedScene = preload("res://trail.tscn")

func _physics_process(delta):
	var target_pos = (get_global_mouse_position() - global_position).normalized()
	velocity = target_pos * speed
	if timer.is_stopped(): 
		print("runs")
		create_trail()
		timer.start()
	move_and_slide()

func _on_hurtbox_area_entered(area):
	cur_health -= 50
	print("ouch! " + str(cur_health))
	if cur_health <= 0:
		print("game over")
		get_tree().paused = true

func create_trail():
	var trail_inst = trail.instantiate()
	get_tree().current_scene.add_child(trail_inst)
	trail_inst.global_position = global_position + Vector2(-25, -25)
	trail_inst.scale = Vector2(0.5, 0.5)
	trail_inst.z_index = 1
