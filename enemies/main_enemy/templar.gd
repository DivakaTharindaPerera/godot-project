extends CharacterBody2D

var SPEED = 50
var player
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity * delta
	player = get_node("../MainPlayer")
	if chase == true:
		var direction = (player.position - self.position).normalized()
	
		if direction.x > 0 :
			get_node("AnimatedSprite2D").flip_h = false
		else :
			get_node("AnimatedSprite2D").flip_h = true

		velocity.x = direction.x * SPEED
		if $AnimatedSprite2D.animation != "death" and $AnimatedSprite2D.animation != "attack" :
			$AnimatedSprite2D.play("run")
	else:
		velocity.x = 0
		if $AnimatedSprite2D.animation != "death" and $AnimatedSprite2D.animation != "attack":
			$AnimatedSprite2D.play("idle")
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "player" || body.name == "MainPlayer":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "player" || body.name == "MainPlayer":
		chase = false

#func _on_dead_body_entered(body):
	#if body.name == "player":
	#	$AnimatedSprite2D.play("death")
	#	await $AnimatedSprite2D.animation_finished
	#	self.queue_free()


func _on_attack_body_entered(body):
	if body.name == "player" || body.name == "MainPlayer":
		$AnimatedSprite2D.play("attack")
		body.health -= 10
