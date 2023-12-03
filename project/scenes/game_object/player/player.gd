extends CharacterBody2D

@export var arena_time_manager: Node

@onready var heal_animation = $HealAnimation
@onready var health_bar = $HealthBar
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var sprite_2d = $Visuals/Sprite2D
@onready var character = MetaProgression.save_data["character"]
var number_colliding_bodies = 0
var base_speed = 0
var last_received_damage = 0

func _ready():
	heal_animation.hide()
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	base_speed = velocity_component.max_speed
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	sprite_2d.texture = load(character["sprite_path"])
	update_health_display()


func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector():
	# returns input state
	# keyboard is binary strength 0 or 1, but on joystick you get fractional so this is relevant for joypad. just fyi xd
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage(damage: int):
	last_received_damage = damage
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(damage)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func _on_collision_area_2d_body_entered(body):
	number_colliding_bodies += 1
	check_deal_damage(body.damage)


func _on_collision_area_2d_body_exited(_body):
	number_colliding_bodies -= 1


func _on_damage_interval_timer_timeout():
	check_deal_damage(last_received_damage)


func _on_health_component_health_decreased():
	GameEvents.emit_player_damage()
	update_health_display()
	$HitRandomStreamPlayer.play_random()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability_controller = ability_upgrade as Ability
		abilities.add_child(ability_controller.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)


func _on_collision_area_2d_area_entered(area):
	number_colliding_bodies += 1
	check_deal_damage(area.damage)


func _on_collision_area_2d_area_exited(_area):
	number_colliding_bodies -= 1


func on_arena_difficulty_increased(difficulty: int):
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regen")
	if health_regeneration_quantity > 0:
		var is_thirty_second_interval = (difficulty % 6) == 0
		if is_thirty_second_interval:
			health_component.heal(health_regeneration_quantity)


func _on_health_component_health_increased():
	update_health_display()
	heal_animation.show()
	heal_animation.play("default")
	await heal_animation.animation_finished
	heal_animation.stop()
	heal_animation.hide()
