extends State

@export var return_state : State

@onready var timer : Timer = $Timer

func state_input(event : InputEvent):
	if event.is_action_pressed("attack"):
		timer.start()

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack1" :
		if timer.is_stopped():
			print("stuck here 1")
			next_state = return_state
			playback.travel("move")
		else:
			print("stuck here 2")
			playback.travel("attack2")
			
	elif anim_name == "attack2"  :
		print("stuck here 3")
		next_state = return_state
		playback.travel("move")
	
	else:
		next_state = return_state
