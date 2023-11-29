extends PanelContainer

@onready var name_label = $MarginContainer/VBoxContainer/PanelContainer/NameLabel
@onready var description_label = $MarginContainer/VBoxContainer/DescriptionLabel


func set_meta_upgrade(upgrade: MetaUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func select_card():
	$AnimationPlayer.play("selected")


func _on_gui_input(event):
	if event.is_action_pressed("left_click"):
		select_card()
