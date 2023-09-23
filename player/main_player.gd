extends CharacterBody2D


@export var health : float = 100 :
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_player_health_changed", self, value - health)
		health = value

@export var SPEED : float = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var anim_sprite : Sprite2D = $Sprite2D
@onready var anim_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO

signal facing_direction_changed(facing_right : bool)
signal omg_hit(direction : Vector2)

func _ready():
	#anim_sprite.play("idle")
	anim_tree.active = true
	SignalBus.connect("heal", increase_player_health)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation_parameters()
	update_direction()

func update_animation_parameters():
	anim_tree.set("parameters/move/blend_position", direction.x)

func update_direction():
	if direction.x > 0:
		anim_sprite.flip_h = false
	elif direction.x < 0:
		anim_sprite.flip_h = true

	emit_signal("facing_direction_changed", !anim_sprite.flip_h)

func me_got_hit(knockback_direction : Vector2):
	emit_signal("omg_hit",knockback_direction)

func increase_player_health (heal_amount : int):
	health += heal_amount
