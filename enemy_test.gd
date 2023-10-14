extends CharacterBody2D

@export var speed : int
@onready var player = get_tree().get_root().get_node("MainScene/Player") 
@onready var health: int = 1

@onready var body : PackedScene = preload("res://body.tscn")

func _physics_process(delta):
	if health <= 0:
		die()
	var target_postion = (player.global_position - global_position).normalized()
	velocity = target_postion * speed
	if !player.alive: velocity = -velocity
	move_and_slide()

func die():
	var body_inst = body.instantiate()
	get_tree().current_scene.add_child(body_inst)
	body_inst.global_position = global_position
	queue_free()
	
func _on_hurtbox_area_entered(area):
	health -= 1
