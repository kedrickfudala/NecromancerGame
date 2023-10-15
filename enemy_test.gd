extends CharacterBody2D

@export var speed : int
@onready var player = get_tree().get_root().get_node("MainScene/Player")
@onready var espawner = get_tree().get_root().get_node("MainScene/enemySpawner")  
@onready var health : int = 1
@onready var animation : int = 0
@onready var angle
@onready var direction
@onready var cur_frame: int = 0
@onready var sprite = $Sprite2D

@onready var body : PackedScene = preload("res://body.tscn")

func _physics_process(_delta):
	if health <= 0:
		die()
	var target_postion = (player.global_position - global_position).normalized()
	velocity = target_postion * speed
	if !player.alive: velocity = -velocity
	move_and_slide()
	
	animation += 1
	angle = atan2(-(player.global_position.y - global_position.y), player.global_position.x - global_position.x)
	#print(angle)
	if !player.alive:
		if angle > 0: angle -= PI
		else: angle += PI
	if angle > -5*PI/8 and angle < - 3*PI/8: direction = 3
	elif angle > -7*PI/8 and angle < -5*PI/8: direction = 4
	elif (angle > -PI and angle < -7*PI/8) or angle > 7*PI/8 and angle < PI: direction = 5
	elif angle > 5*PI/8 and angle < 7*PI/8: direction = 6
	elif angle > 3*PI/8 and angle < 5*PI/8: direction = 7
	elif angle > 1*PI/8 and angle < 3*PI/8: direction = 0
	elif angle > -3*PI/8 and angle < -1*PI/8: direction = 2
	else: direction = 1
	if speed != 0: direction+= 1
	if animation == 5:
		animation = 0
		if cur_frame < 2:
			cur_frame += 1
		else:
			cur_frame = 0
	sprite.frame = direction + (cur_frame*8)
	#print(cur_frame)

func die():
	var body_inst = body.instantiate()
	get_tree().current_scene.add_child(body_inst)
	body_inst.global_position = global_position
	body_inst.scale = Vector2(3, 3)
	body_inst.z_index = 4
	espawner.enemy_num -= 1
	queue_free()
	
func _on_hurtbox_area_entered(_area):
	health -= 1
	print("enemy hurt!")
