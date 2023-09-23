extends CharacterBody2D

var health = 100
@export var SPEED : float = 150.0
@export var JUMP_VELOCITY : float = -400.0
@export var DOUBLE_JUMP_VELOCITY : float = -350.0

@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var double_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var in_air : bool = false

func _ready():
	anim_sprite.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		in_air = true
	else:
		double_jumped = false
		if in_air == true:
			land()
		
		in_air = false

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump()
		elif not double_jumped:
			velocity.y = DOUBLE_JUMP_VELOCITY
			double_jumped = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("backward", "forward","jump", "crouch" )
	if direction.x != 0  and anim_sprite.animation != "fall":
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation()
	update_direction()

func update_animation():
	if not animation_locked:
		if not is_on_floor():
			anim_sprite.play("fall")
		else:
			if direction.x != 0 :
				anim_sprite.play("run")
			else:
				anim_sprite.play("idle")

func update_direction():
	if direction.x > 0:
		anim_sprite.flip_h = false
	elif direction.x < 0 :
		anim_sprite.flip_h = true

func jump():
	anim_sprite.play("jump")
	animation_locked = true

func land():
	anim_sprite.play("fall")
	animation_locked = true
	
func _on_animated_sprite_2d_animation_finished():
	if (anim_sprite.animation == "fall"):
		animation_locked = false
