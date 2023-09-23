extends State

class_name  AirState

@export var landing_state : State
@export var ground_state : State
@export var DOUBLE_JUMP_VELOCITY : float = -200.0

var double_jumped = false

func state_process(delta):
	if (character.is_on_floor()):
		next_state = landing_state

func state_input(event : InputEvent):
	if (event.is_action_pressed("jump") and !double_jumped):
		double_jump()

func on_exit():
	if (next_state == landing_state):
		playback.travel("jump_end")
		double_jumped = false

func double_jump():
	character.velocity.y = DOUBLE_JUMP_VELOCITY
	playback.travel("double_jump")
	#anim_sprite.play("jump_double")
	double_jumped = true
