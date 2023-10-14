extends CharacterBody2D

@export var speed : int = 75
@onready var player = get_tree().get_root().get_node("MainScene/playerX") 
@onready var alive: bool = true
@onready var health: int = 1

@onready var body : PackedScene = preload("res://body.tscn")

func _physics_process(delta):
	if health <= 0:
		die()
	var target_postion = (player.global_position - global_position).normalized()
	velocity = target_postion * speed
	if !alive: velocity = -velocity
	move_and_slide()

func die():
	var body_inst = body.instantiate()
	get_tree().current_scene.add_child(body_inst)
	body_inst.global_position = global_position
	queue_free()
