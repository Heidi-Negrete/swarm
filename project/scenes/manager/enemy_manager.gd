extends Node

const SPAWN_RADIUS = 350 # viewport width is 640, use radius circle of 320 + a lil buffer to ensure enemy doesn't spawn in the viewport

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@export var arena_time_manager: Node

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = $Timer.wait_time


func _on_timer_timeout():
	$Timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func _on_arena_time_manager_arena_difficulty_increased(arena_difficulty):
	var time_off = (.1 / 12) * arena_difficulty
	time_off = min(time_off, .7)
	$Timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 3:
		enemy_table.add_item(ghost_enemy_scene, 5)
	
	elif arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 10)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		return Vector2.ZERO
		
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var enemy_collision_offset = 20 * random_direction #20 is enough to account for current collision shapes in game w radius of up to 10px
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + enemy_collision_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)

		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(.25 * TAU)
	
	return spawn_position
