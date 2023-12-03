extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var projectile_scene = preload("res://scenes/ability/projectile_ability/projectile_ability.tscn")
@onready var shoot_timer = $ShootTimer

var damage = 1
var is_moving = false
var in_range = false

func _ready():
	$HurtboxComponent.hit.connect(on_hit)


func _process(_delta):
	if is_moving:
		velocity_component.accelerate_to_in_range()
	else:
		velocity_component.deaccelerate()
		
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func set_is_moving(moving: bool):
	is_moving = moving


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()


func shoot_player():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var projectile_scene_instance = projectile_scene.instantiate() as ProjectileAbility
	var projectile_layer = get_tree().get_first_node_in_group("projectile_layer")
	projectile_layer.add_child(projectile_scene_instance)
	var direction = global_position.direction_to(player.global_position)
	projectile_scene_instance.global_position = global_position + (direction * 10)
	projectile_scene_instance.direction = direction


func _on_shoot_timer_timeout():
	if in_range:
		shoot_player()
