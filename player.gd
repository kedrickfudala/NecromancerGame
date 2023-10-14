extends CharacterBody2D

@export var speed : int = 75
@export var max_health : int = 100
@onready var cur_health : int = max_health

func _physics_process(delta):
	var target_pos = (get_global_mouse_position() - global_position).normalized()
	velocity = target_pos * speed
	move_and_slide()

func _on_hurtbox_area_entered(area):
	cur_health -= 10
	print("ouch!")
