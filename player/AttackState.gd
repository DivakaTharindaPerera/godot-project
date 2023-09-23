extends State

@export var return_state : State

@onready var timer : Timer = $Timer

func state_input(event : InputEvent):
	if event.is_action_pressed("attack"):
		timer.start()

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack1" :
		if timer.is_stopped():
			next_state = return_state
			playback.travel("move")
		else:
			playback.travel("attack2")
			
	if anim_name == "attack2" :
		next_state = return_state
		playback.travel("move")
