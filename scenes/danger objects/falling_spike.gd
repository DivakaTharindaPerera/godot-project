extends Node2D

@export var start_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartTimer.wait_time = start_time
	$StartTimer.start()

func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "MainPlayer":
		body.health -= 30
		var direction = body.global_position - self.global_position
		var direction_sign = sign(direction.x)

		if direction_sign > 0:
			body.me_got_hit(Vector2.RIGHT)
		elif direction_sign < 0 :
			body.me_got_hit(Vector2.LEFT)
		else:
			body.me_got_hit(Vector2.ZERO)


func _on_start_timer_timeout():
	$AnimationPlayer.play("fall")
