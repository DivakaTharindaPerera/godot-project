extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var sprite : Sprite2D = $Sprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var SPEED : float = 30.0

@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Add the gravity.

	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : Vector2 = starting_move_direction
	if direction and state_machine.check_if_can_move():
		velocity.y = direction.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


func _on_area_2d_body_entered(body):
	print(body.name)
	if body.name == "NPCBorders" :
		starting_move_direction.y = starting_move_direction.y * -1
	elif body.name == "MainPlayer":
		body.health -= 20
		var direction = body.global_position - self.global_position
		var direction_sign = sign(direction.x)

		if direction_sign > 0:
			body.me_got_hit(Vector2.RIGHT)
		elif direction_sign < 0 :
			body.me_got_hit(Vector2.LEFT)
		else:
			body.me_got_hit(Vector2.ZERO)
