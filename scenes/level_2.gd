extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(CurrentVariables.current_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CurrentVariables.current_level = 2


func _on_area_2d_body_entered(body):
	if body.name == "MainPlayer":
		get_tree().change_scene_to_file("res://scenes/level_2_completed.tscn")
