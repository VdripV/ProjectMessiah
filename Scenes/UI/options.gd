extends Control

const SETTINGS_FILE = "user://settings.cfg"
const BUS_NAME = "SFX"
const DEFAULT_VOLUME = 70.0
const DEFAULT_SENSITIVITY = 2
const MAX_HORIZONTAL_SENS = 1
const MAX_VERTICAL_SENS = 4

@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/VolumeChange/HSlider
@onready var sensitivity_slider: HSlider = $MarginContainer/VBoxContainer/SensitivityChange/HSlider

func _ready():
	load_settings()
	volume_slider.value_changed.connect(_on_volume_changed)
	sensitivity_slider.value_changed.connect(_on_sensitivity_changed)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func load_settings():
	var config = ConfigFile.new()
	if config.load(SETTINGS_FILE) != OK:
		volume_slider.value = DEFAULT_VOLUME
		sensitivity_slider.value = DEFAULT_SENSITIVITY
	else:
		volume_slider.value = config.get_value("audio", "sfx_volume", DEFAULT_VOLUME)
		sensitivity_slider.value = config.get_value("controls", "sensitivity", DEFAULT_SENSITIVITY)
	
	_apply_volume_from_slider()
	_apply_sensitivity_from_slider()

func save_volume(value: float):
	var config = ConfigFile.new()
	config.load(SETTINGS_FILE)
	config.set_value("audio", "sfx_volume", value)
	config.save(SETTINGS_FILE)

func save_sensitivity(value: float):
	var config = ConfigFile.new()
	config.load(SETTINGS_FILE)
	config.set_value("controls", "sensitivity", value)
	config.save(SETTINGS_FILE)

func _apply_volume_from_slider():
	_on_volume_changed(volume_slider.value)

func _on_volume_changed(value: float):
	var linear_volume = value / 100.0
	var bus_idx = AudioServer.get_bus_index(BUS_NAME)
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear_volume))
	save_volume(value)

func _apply_sensitivity_from_slider():
	_on_sensitivity_changed(sensitivity_slider.value)

func _on_sensitivity_changed(value: float):
	if global.player:
		global.player.HORIZONTAL_SENS = value * MAX_HORIZONTAL_SENS
		global.player.VERTICAL_SENS = value * MAX_VERTICAL_SENS
		print(global.player.HORIZONTAL_SENS)
	save_sensitivity(value)

func _input(event: InputEvent):
	if Input.is_action_just_pressed("menu"):

		get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")
		
