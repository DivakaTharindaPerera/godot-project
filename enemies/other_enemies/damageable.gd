extends Node

class_name Damageable

signal on_hit(node : Node, damage_taken : int, knockback_direction : Vector2)

@export var health : float = 50 :
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed", get_parent(), value - health)
		health = value

func hit(damage : int, knockeback_direction : Vector2):
	health -= damage
	
	emit_signal("on_hit", get_parent(), damage, knockeback_direction)
	
#	if health <= 0 :
#		get_parent().queue_free(
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "dead":
		get_parent().queue_free()
