extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_button_pressed():
	# Load the game scene here
	print("Start Game button pressed")  # Add this line for debugging
	# var game_scene = preload()  # Adjust the path to your game scene
	get_tree().change_scene_to_file("res://level.tscn")
