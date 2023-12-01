extends CanvasLayer

signal back_pressed

@onready var window_button: Button = %WindowButton
@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var back_button = %BackButton


func _ready():
	update_display()
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))


func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	sfx_slider.value = AudioManager.get_bus_volume_percent("sfx")
	music_slider.value = AudioManager.get_bus_volume_percent("music")


func save_changes():
	MetaProgression.save_data["sfx"] = AudioManager.get_bus_volume_percent("sfx")
	MetaProgression.save_data["music"] = AudioManager.get_bus_volume_percent("music")
	MetaProgression.save_data["fullscreen"] = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	MetaProgression.save()

func _on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()


func on_audio_slider_changed(value: float, bus_name: String):
	AudioManager.set_bus_volume_percent(bus_name, value)


func _on_back_button_pressed():
	save_changes()
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	back_pressed.emit()
