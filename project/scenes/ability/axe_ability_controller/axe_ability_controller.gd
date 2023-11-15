extends Node

@export var axe_ability_scene: PackedScene

var damage = 10


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		print('player is null')
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null:
		print('player null')
		return
		
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage
