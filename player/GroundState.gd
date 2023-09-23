extends State

class_name GroundState

@export var JUMP_VELOCITY : float = -250.0
@export var air_state : State
@export var attack_state : State

@onready var buffer_timer : Timer = $BufferTimer

func state_process(delta):
	if (!character.is_on_floor() and buffer_timer.is_stopped()):
		next_state = air_state

func state_input(event : InputEvent):
	if (event.is_action_pressed("jump")):
		jump()
	if event.is_action_pressed("attack"):
		attack()

func jump():
	character.velocity.y = JUMP_VELOCITY
	next_state = air_state
	playback.travel("jump_start")

func attack():
	next_state = attack_state
	playback.travel("attack1")
