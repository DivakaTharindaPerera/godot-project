extends CharacterBody2D

@export var SPEED : float = 100.0
@export var x_starting_point : float
@export var x_ending_point : float
@export var y_starting_point : float
@export var y_ending_point : float
@export var starting_direction : Vector2

func _physics_process(delta):
	
	if self.position.x > x_ending_point or  self.position.x < x_starting_point:
		starting_direction.x = starting_direction.x * -1
	
	velocity.x = SPEED * starting_direction.x
	
	if self.position.y > y_ending_point or  self.position.y < y_starting_point:
		starting_direction.y = starting_direction.y * -1
	
	velocity.y = SPEED * starting_direction.y
	
	move_and_slide()
