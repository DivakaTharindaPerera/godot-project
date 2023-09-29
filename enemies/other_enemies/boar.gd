extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var sprite : Sprite2D = $Sprite2D

@export var facing_direction : CollisionShape2D
@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var SPEED : float = 30.0
@export var hit_state : State

@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

signal facing_direction_changed_boar(facing_right : bool)

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : Vector2 = starting_move_direction
	if direction and state_machine.check_if_can_move():
		velocity.x = direction.x * SPEED
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_direction()


func _on_area_2d_body_entered(body):
	if body.name == "StaticBody2D" || body.name == "WorldCollisions" || body.name == "NPCBorders" :
		starting_move_direction.x = starting_move_direction.x * -1
		if starting_move_direction[0] != -1 :
			sprite.flip_h = true
			facing_direction.position = facing_direction.facing_right
		else :
			sprite.flip_h = false
			facing_direction.position = facing_direction.facing_left
	
	elif body.name == "MainPlayer" :
		body.health -= 10
		
		var direction = body.global_position - self.global_position
		var direction_sign = sign(direction.x)
		
		if direction_sign > 0:
			body.me_got_hit(Vector2.RIGHT)
		elif direction_sign < 0 :
			body.me_got_hit(Vector2.LEFT)
		else:
			body.me_got_hit(Vector2.ZERO)

func update_direction():
	if starting_move_direction.x > 0:
		sprite.flip_h = true
	elif starting_move_direction.x < 0:
		sprite.flip_h = false

	emit_signal("facing_direction_changed_boar", sprite.flip_h)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "dead":
		queue_free()
