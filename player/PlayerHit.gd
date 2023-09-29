extends State

@export var return_state : State
@export var parent : CharacterBody2D
@export var knockback_velocity : Vector2 = Vector2(500,0)
@export var dead_state : State

func _ready():
	parent.connect("omg_hit", on_hit_function)
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "hit" :
		next_state = return_state
		playback.travel("move")

func on_hit_function(direction : Vector2):
	if character.health > 0:
		character.velocity = knockback_velocity * direction
		playback.travel("hit")
	else:
		emit_signal("interrupt_state", dead_state)
		playback.travel("dead")
