extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var hurtbox_component = $HurtboxComponent

func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(_delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
