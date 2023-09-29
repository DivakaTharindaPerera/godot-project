extends CharacterBody2D


@export var SPEED : float = 50
@export var attack_collision : CollisionShape2D
@export var attack_range : CollisionShape2D
@export var attack_timer : Timer
@export var knockback_velocity : Vector2 = Vector2(30, 0)
@export var attack_damage : float

@onready var damageable : Damageable = $Damageable

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var body_in_chase : bool = false
var body_in_attack_range : bool = false
var body_direction = 0
var attacked : bool = false
var player_body
var dead : bool = false


func _ready():
	body_in_chase = false
	body_in_attack_range = false
	$AnimationPlayer.play("idle")
	damageable.connect("on_hit", on_damageable_hit)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if body_in_chase == true and dead == false:
		velocity.x = SPEED * body_direction
		$AnimationPlayer.play("run")
	elif body_in_attack_range == true and dead == false:
		velocity.x = 0
		if attacked == false:
			$AnimationPlayer.play("attack")
			attack_timer.start()
		else:
			$AnimationPlayer.play("idle")
	elif dead == false:
		velocity.x = 0
		$AnimationPlayer.play("idle")

	if body_direction > 0 :
		$Sprite2D.flip_h = false
		attack_collision.position = Vector2( 16, 5.5 )
		attack_range.position = Vector2( 13.625, 5.5 )
	elif body_direction < 0 :
		$Sprite2D.flip_h = true
		attack_collision.position = Vector2( -16, 5.5 )
		attack_range.position = Vector2( -13.625, 5.5 )
	
	move_and_slide()

func _on_chase_body_entered(body):
	if body.name == "MainPlayer":
		var direction = body.global_position - self.global_position
		body_direction = sign(direction.x)
		body_in_chase = true

func _on_chase_body_exited(body):
	if body.name == "MainPlayer":
		body_in_chase = false

func _on_attack_range_body_entered(body):
	if body.name == "MainPlayer" :
		body_in_attack_range = true
		body_in_chase = false
		player_body = body

func _on_attack_range_body_exited(body):
	if body.name == "MainPlayer" :
		body_in_attack_range = false
		body_in_chase = true
		player_body = null

func _on_attack_interval_timeout():
	attacked = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		attacked = true
		if player_body != null:
			player_body.health -= attack_damage
			if body_direction > 0:
				player_body.me_got_hit(Vector2.RIGHT)
			else :
				player_body.me_got_hit(Vector2.LEFT)
	
	if anim_name == "dead":
		queue_free()

func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	print(damageable.health)
	if damageable.health > 0:
		print("knockback")
		self.velocity = knockback_velocity * knockback_direction
	else:
		$AnimationPlayer.play("dead")
		dead = true
