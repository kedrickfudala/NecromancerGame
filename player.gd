extends CharacterBody2D

@onready var target_pos = Vector2(0, 0)
@export var speed : int = 500
@onready var max_speed = speed
@export var max_health : int = 100
@onready var cur_health : int = max_health
@onready var trail_timer = $TrailTimer
@onready var ghost_timer = $GhostTimer
@onready var total_souls : int = 0
@onready var cur_souls : int = 0
@export var alive : bool = true
@onready var boost: float = 0
@onready var x = 0
@onready var sprite = $Sprite2D
@export var soul_goal : int = 10
@export var soul_revive_goal : int = 2

@onready var animation: int = 0
@onready var cur_frame: int = 0
@onready var direction: int = 0
@onready var color_mod = Color(1, 1, 1, 1)
@onready var result = 0

@onready var trail : PackedScene = preload("res://trail.tscn")
@onready var body : PackedScene = preload("res://player_body.tscn")
@onready var floater : PackedScene = preload("res://floating_soul.tscn")
@onready var overlay = get_tree().get_root().get_node("MainScene/CanvasLayer/overlay")

func _ready():
	global_position = to_global(Vector2(0, 0))
	ghost_timer.set_paused(true)

func _physics_process(delta):
	x += delta
	target_pos = (get_global_mouse_position() - global_position).normalized()

	if global_position.distance_to(get_global_mouse_position()) > 200:
		speed = max_speed
	else:
		speed = 0
	velocity = target_pos * (speed + boost)

	move_and_slide()
	
	if alive:
		if Input.is_action_pressed("left_click"):
			if trail_timer.is_stopped(): 
				create_trail()
				trail_timer.start()
		if Input.is_action_just_pressed("right_click"):
			boost = -1800
			var launch = create_trail()
			launch.launched = true
			for i in range(4):
				launch = create_trail()
				launch.launched = true
				launch.angle = (1+i)*PI/16
				launch = create_trail()
				launch.launched = true
				launch.angle = -(1+i)*PI/16
		color_mod = Color(1, 1, 1, 1)
		color_mod.v = 1
	else:
		color_mod = Color(1, 1, 1, 0.5)
		color_mod.v = 2
	
	modulate = color_mod
	
	if ghost_timer.is_stopped(): 
		print("game over")
		overlay.resultText.text = ("Game OVER!")
		get_tree().paused = true
		
	boost *= 0.95
	
	animation += 1
	var angle = atan2(-(get_global_mouse_position().y - global_position.y), get_global_mouse_position().x - global_position.x)
	#print(angle)
	if angle > -5*PI/8 and angle < - 3*PI/8: direction = 0
	elif angle > -7*PI/8 and angle < -5*PI/8: direction = 3
	elif (angle > -PI and angle < -7*PI/8) or angle > 7*PI/8 and angle < PI: direction = 6
	elif angle > 5*PI/8 and angle < 7*PI/8: direction = 9
	elif angle > 3*PI/8 and angle < 5*PI/8: direction = 12
	elif angle > 1*PI/8 and angle < 3*PI/8: direction = 21
	elif angle > -3*PI/8 and angle < -1*PI/8: direction = 15
	else: direction = 18
	if speed != 0: direction+= 1
	if animation == 5:
		animation = 0
		if cur_frame < sprite.hframes - 1:
			cur_frame += 1
		else:
			cur_frame = 0
	sprite.frame = (direction*6) + cur_frame

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
	return trail_inst
	
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
	if cur_souls < soul_revive_goal: # set < num of souls required to resurrect 
		cur_souls += 1
		var soul_inst = floater.instantiate()
		get_tree().current_scene.add_child(soul_inst)
		soul_inst.scale = Vector2(3, 3)
