extends Node2D

@export var opened_box : Sprite2D
@export var closed_box : Sprite2D

var collected : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_detect_body_entered(body):
	if collected != true:
		if body.name == "MainPlayer":
			print("health ++ ")
			opened_box.visible = true
			closed_box.visible = false
			SignalBus.emit_signal("heal", 25)
			collected = true
	
	
