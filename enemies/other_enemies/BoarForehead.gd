extends Area2D

@export var facing_shape : CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_boar_facing_direction_changed_boar(facing_right):
	if facing_right:
		facing_shape.position = facing_shape.facing_right
	else:
		facing_shape.position = facing_shape.facing_left
