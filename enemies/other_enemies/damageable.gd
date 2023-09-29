extends Node

class_name Damageable

signal on_hit(node : Node, damage_taken : int, knockback_direction : Vector2)

@export var health : float = 50 :
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed", get_parent(), value - health)
		SignalBus.emit_signal("health_to_health_bar", value)
		health = value

func hit(damage : int, knockeback_direction : Vector2):
	health -= damage
	
	emit_signal("on_hit", get_parent(), damage, knockeback_direction)

