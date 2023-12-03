extends Node2D
class_name ProjectileAbility

@export var speed: int = 200

@onready var hitbox_component = $HitboxComponent
@onready var is_moving = false
@onready var velocity = Vector2.ZERO
@onready var direction = Vector2.RIGHT

func _ready():
	hitbox_component.damage = 2
	get_tree().create_timer(.4)
	is_moving = true


func _process(delta):
	if is_moving:
		global_position += direction * speed * delta


func _on_collision_area_2d_body_entered(_body):
	queue_free()
