extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -450.0

var health = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO

@onready var anim = get_node("AnimationPlayer")
@onready var anim_tree : AnimationTree = $AnimationTree

func _ready():
	anim_tree.active = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("backward", "forward", "jump", "crouch")

	if direction.x == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction.x == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
		velocity.x = direction.x * SPEED
		if velocity.y == 0:
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("idle")
	if velocity.y > 0:
		anim.play("fall")
	move_and_slide()
	update_animation()
	
func update_animation():
	anim_tree.set("parameters/move/blend_position", direction.x)

