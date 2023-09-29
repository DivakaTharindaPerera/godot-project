extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentVariables.current_level = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_end_body_entered(body):
	if body.name == "MainPlayer":
		get_tree().change_scene_to_file("res://scenes/level_3_completed.tscn")
