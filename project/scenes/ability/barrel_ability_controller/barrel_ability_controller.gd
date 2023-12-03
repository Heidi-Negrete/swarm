extends Node

const BASE_RANGE = 150

@export var barrel_ability_scene: PackedScene

var damage = 20

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * randf_range(0, BASE_RANGE))
	
	var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
	if !result.is_empty():
		spawn_position = result["position"]
	
	var barrel_ability = barrel_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(barrel_ability)
	barrel_ability.hitbox_component.damage = damage
	barrel_ability.global_position = spawn_position
