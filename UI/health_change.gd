extends Control

@export var health_changed_label : PackedScene
@export var player_damage_color : Color = Color.DARK_RED
@export var enemy_damage_color : Color = Color.DARK_BLUE
@export var heal_color : Color = Color.DARK_GREEN

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("on_health_changed", on_signal_health_change)
	SignalBus.connect("on_player_health_changed", on_signal_player_health_change)

func _process(delta):
	pass

func on_signal_health_change(node: Node, amount_changed : int):
	var label_instance : Label = health_changed_label.instantiate()
	node.add_child(label_instance)
	label_instance.text = str(amount_changed)

	if amount_changed >= 0:
		label_instance.modulate = heal_color
	else:
		label_instance.modulate = enemy_damage_color

func on_signal_player_health_change(node: Node, amount_changed : int):
	var label_instance : Label = health_changed_label.instantiate()
	node.add_child(label_instance)

	if amount_changed >= 0:
		label_instance.text = "+"+str(amount_changed)
		label_instance.modulate = heal_color
	else:
		label_instance.text = str(amount_changed)
		label_instance.modulate = player_damage_color
	
