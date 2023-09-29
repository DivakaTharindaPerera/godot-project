extends CharacterBody2D

@export var SPEED : float = 50
@export var attack_collision : CollisionShape2D
@export var attack_range : CollisionShape2D
@export var attack_timer : Timer
@export var attack_damage : float
@export var knockback_velocity : Vector2 = Vector2(30, 0)
@export var health_bar : ProgressBar
@export var health_bar_parent : Control

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var body_in_chase : bool = false
var body_in_attack_range : bool = false
var body_direction = 0
var attacked : bool = false
var player_body
var dead : bool = false

@onready var damageable : Damageable = $Damageable

# Called when the node enters the scene tree for the first time.
func _ready():
	body_in_chase = false
	body_in_attack_range = false
	$AnimationPlayer.play("idle") 
	damageable.connect("on_hit", on_damageable_hit)
	SignalBus.connect("health_to_health_bar", change_health_bar)
	health_bar.value = 100
	health_bar_parent.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if body_in_chase == true and dead == false and player_body != null:
		var direction = player_body.global_position - self.global_position
		body_direction = sign(direction.x)
		velocity.x = SPEED * body_direction
		$AnimationPlayer.play("walk")
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
		attack_collision.position = Vector2( 21.25, 7 )
		attack_range.position = Vector2( 22.221, 7.155 )
	elif body_direction < 0 :
		$Sprite2D.flip_h = true
		attack_collision.position = Vector2( -21.25, 7 )
		attack_range.position = Vector2( -22.221, 7.155  )
	
	move_and_slide()

func _on_chase_body_entered(body):
	if body.name == "MainPlayer":
		player_body = body
		body_in_chase = true

func _on_chase_body_exited(body):
	if body.name == "MainPlayer":
		body_in_chase = false


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
		SignalBus.emit_signal("boss_defeated")
		queue_free()


func _on_attack_interval_timeout():
	attacked = false # Replace with function body.


func _on_attack_range_body_entered(body):
	if body.name == "MainPlayer" :
		print("in attack range")
		body_in_attack_range = true
		body_in_chase = false
		player_body = body

func _on_attack_range_body_exited(body):
	if body.name == "MainPlayer" :
		body_in_attack_range = false
		body_in_chase = true
		player_body = body

func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	print(damageable.health)
	if damageable.health > 0:
		print("knockback")
		self.velocity = knockback_velocity * knockback_direction
	else:
		$AnimationPlayer.play("dead")
		dead = true

func change_health_bar(amount : float):
	var val : float = amount / 150 * 100
	health_bar.value = val
