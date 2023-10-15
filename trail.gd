extends StaticBody2D

@onready var launched : bool = false
@onready var first : bool = false
@onready var speed : float = 15
@onready var direction
@onready var angle = 0

func _process(_delta):
	if launched:
		if !first:
			direction = (get_global_mouse_position()-global_position).normalized()
			direction = direction.rotated(angle)
		first = true
		global_position += (direction * speed)
		speed *= 0.96
		if speed < 0.5: launched = false
