extends CanvasLayer
class_name OptionsMenu

signal back_pressed

@onready var sfx_slider: HSlider = $%sfx_slider
@onready var bgm_slider: HSlider = $%bgm_slider
@onready var window_mode_button: SoundButton = $%window_mode_button
@onready var back_button: SoundButton = %back_button


func _ready() -> void:
	window_mode_button.pressed.connect(_on_window_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	sfx_slider.value_changed.connect(_on_audio_slider_changed.bind("SFX"))
	bgm_slider.value_changed.connect(_on_audio_slider_changed.bind("BGM"))
	update_display()


func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("escape")):
		back_pressed.emit()


func update_display():
	window_mode_button.text = "Windowed"
	if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
		window_mode_button.text = "Fullscreen"
	sfx_slider.value = get_bus_volume_percent("SFX")
	bgm_slider.value = get_bus_volume_percent("BGM")


func get_bus_volume_percent(bus_name: String):
	var bus_index:= AudioServer.get_bus_index(bus_name)
	var volume_db:= AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index:= AudioServer.get_bus_index(bus_name)
	var volume_db:= linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)


func _on_window_button_pressed():
	var mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	if (mode != DisplayServer.WINDOW_MODE_FULLSCREEN):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	update_display()


func _on_back_button_pressed():
	back_pressed.emit()
