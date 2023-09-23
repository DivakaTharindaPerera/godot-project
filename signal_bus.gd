extends Node

signal on_health_changed(node : Node, amount_changed : int)
signal on_player_health_changed(node : Node, amount_changed : int)
signal player_hit()
signal game_over()
signal heal(heal_amount : int)
