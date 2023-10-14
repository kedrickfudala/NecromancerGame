extends Control

@onready var main_level : PackedScene = preload("res://level.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_button_pressed():
	# Load the game scene here
	print("Start Game button pressed")  # Add this line for debugging
	get_tree().change_scene_to_packed(main_level)
