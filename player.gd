extends CharacterBody2D

@onready var target_pos = Vector2(0, 0)
@export var speed : int
@export var max_health : int = 100
@onready var cur_health : int = max_health
@onready var trail_timer = $TrailTimer
@onready var ghost_timer = $GhostTimer
@onready var souls : int = 0
@onready var alive : bool = true

@onready var trail : PackedScene = preload("res://trail.tscn")

func _ready():
	z_index = 4

func _physics_process(_delta):
	target_pos = (get_global_mouse_position() - global_position).normalized()
	velocity = target_pos * speed
	if Input.is_action_pressed("left_click"):
		if trail_timer.is_stopped(): 
			create_trail()
			trail_timer.start()
	move_and_slide()
	set_collision_mask_value(5, !alive)

func _on_hurtbox_area_entered(_area):
	cur_health -= 50
	print("ouch! " + str(cur_health))
	if cur_health <= 0:
		print("game over")
		get_tree().paused = true

func create_trail():
	var trail_inst = trail.instantiate()
	get_tree().current_scene.add_child(trail_inst)
	trail_inst.global_position = global_position + (target_pos * -1)
	trail_inst.scale = Vector2(1, 1)
	trail_inst.z_index = 1
