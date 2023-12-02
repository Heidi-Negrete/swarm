extends CanvasLayer

@export var character_images: Array[PlayerCharacter] = []

@onready var grid_container = $VBoxContainer/ScrollContainer/MarginContainer/GridContainer

var character_card_scene = preload("res://scenes/user_interface/character_card.tscn")


func _ready():
	for character in character_images:
		var character_card_instance = character_card_scene.instantiate()
		grid_container.add_child(character_card_instance)
		character_card_instance.set_character(character)
		character_card_instance.char_selected.connect(on_character_selected.bind(character))


func _on_back_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/user_interface/main_menu.tscn")


func on_character_selected(character: PlayerCharacter):
	MetaProgression.save_data["character"] = inst_to_dict(character)
	MetaProgression.save()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
