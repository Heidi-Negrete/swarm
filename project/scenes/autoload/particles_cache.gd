extends CanvasLayer


var death_particles_material = preload("res://materials/death_component.material")
var barrel_particles_material = preload("res://materials/barrel_ability.material")

var materials: Array = [
	death_particles_material,
	barrel_particles_material,
]

func _ready():
	for material in materials:
		var particles_instance = GPUParticles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
