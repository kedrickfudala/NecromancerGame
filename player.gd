extends CharacterBody2D

@onready var target_pos = Vector2(0, 0)
@export var speed : int
@export var max_health : int = 100
@onready var cur_health : int = max_health
@onready var trail_timer = $TrailTimer
@onready var ghost_timer = $GhostTimer
@onready var total_souls : int = 0
@onready var cur_souls : int = 0
@export var alive : bool = true
@onready var boost: int = 0

@onready var trail : PackedScene = preload("res://trail.tscn")
@onready var body : PackedScene = preload("res://player_body.tscn")

func _ready():
	global_position = to_global(Vector2(0, 0))
	z_index = 4
	ghost_timer.set_paused(true)

func _physics_process(_delta):
	
	target_pos = (get_global_mouse_position() - global_position).normalized()
	velocity = target_pos * (speed + boost)
	move_and_slide()
	
	if Input.is_action_pressed("left_click") and alive:
		if trail_timer.is_stopped(): 
			create_trail()
			trail_timer.start()
	
	if ghost_timer.is_stopped(): 
		print("game over")
		get_tree().paused = true
		
	if boost > 0: boost -= 10
	
	#set_collision_mask_value(5, !alive)

func _on_hurtbox_area_entered(_area):
	if alive:
		cur_health -= 50
		print("ouch! my health is " + str(cur_health))
		if cur_health <= 0:
			ghost_mode()
#			print("game over")
#			get_tree().paused = true
			

func create_trail():
	var trail_inst = trail.instantiate()
	get_tree().current_scene.add_child(trail_inst)
	trail_inst.global_position = global_position + (target_pos * -1)
	trail_inst.scale = Vector2(1, 1)
	trail_inst.z_index = 1
	
func ghost_mode():
	alive = false
	set_collision_mask_value(5, true)
	var body_inst = body.instantiate()
	get_tree().current_scene.add_child(body_inst)
	body_inst.global_position = global_position + (target_pos * -1)
	body_inst.scale = Vector2(3, 3)
	body_inst.z_index = 1
	ghost_timer.start()
	ghost_timer.set_paused(false)
	boost = 600
	
func resurrect():
	alive = true
	cur_health = max_health
	set_collision_mask_value(5, false)
	ghost_timer.set_paused(true)
	ghost_timer.start()
	cur_souls = 0
