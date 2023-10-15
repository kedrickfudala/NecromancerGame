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
@onready var boost: float = 0
@onready var x = 0

@onready var trail : PackedScene = preload("res://trail.tscn")
@onready var body : PackedScene = preload("res://player_body.tscn")
@onready var floater : PackedScene = preload("res://floating_soul.tscn")

func _ready():
	global_position = to_global(Vector2(0, 0))
	ghost_timer.set_paused(true)

func _physics_process(delta):
	x += delta
	print(x)
	if global_position.distance_to(get_global_mouse_position()) > 200:
		target_pos = (get_global_mouse_position() - global_position).normalized()
		velocity = target_pos * (speed + boost)
	else:
		velocity = Vector2(0, 0)

	move_and_slide()
	
	if alive:
		if Input.is_action_pressed("left_click"):
			if trail_timer.is_stopped(): 
				create_trail()
				trail_timer.start()
		if Input.is_action_pressed("right_click"):
			boost = -1800
	
	if ghost_timer.is_stopped(): 
		print("game over")
		get_tree().paused = true
		
	boost *= 0.95
	
	#set_collision_mask_value(5, !alive)

func _on_hurtbox_area_entered(_area):
	if alive:
		cur_health -= 50
		print("ouch! my health is " + str(cur_health))
		if cur_health <= 0:
			ghost_mode()

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
	
func harvest_soul():
	total_souls += 1
	if cur_souls < 2: # set < num of souls required to resurrect 
		cur_souls += 1
		var soul_inst = floater.instantiate()
		get_tree().current_scene.add_child(soul_inst)
		soul_inst.scale = Vector2(3, 3)
