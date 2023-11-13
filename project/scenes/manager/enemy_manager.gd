extends Node

const SPAWN_RADIUS = 350 # viewport width is 640, use radius circle of 320 + a lil buffer to ensure enemy doesn't spawn in the viewport

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

var base_spawn_time = 0


func _ready():
	base_spawn_time = $Timer.wait_time


func _on_timer_timeout():
	$Timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	var enemy = basic_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position


func _on_arena_time_manager_arena_difficulty_increased(arena_difficulty):
	var time_off = (.1 / 12) * arena_difficulty
	time_off = min(time_off, .7)
	$Timer.wait_time = base_spawn_time - time_off
