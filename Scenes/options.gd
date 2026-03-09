extends Control

const BUS_NAME = "SFX"
const SETTINGS_FILE = "user://settings.cfg"
const DEFAULT_VOLUME = 70.0
@onready var h_slider = $MarginContainer/VBoxContainer/VolumeChange/HSlider

func _ready():
	load_volume()
	h_slider.value_changed.connect(_on_volume_changed)

func _on_volume_changed(value: float):
	var linear_volume = value / 100.0
	var bus_idx = AudioServer.get_bus_index(BUS_NAME)
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear_volume))
	save_volume(value)

func save_volume(value: float):
	var config = ConfigFile.new()
	config.set_value("audio", "sfx_volume", value)
	config.save(SETTINGS_FILE)

func load_volume():
	var config = ConfigFile.new()
	
	if config.load(SETTINGS_FILE) != OK:
		h_slider.value = DEFAULT_VOLUME
	else:
		var saved_value = config.get_value("audio", "sfx_volume", DEFAULT_VOLUME)
		h_slider.value = saved_value
	_apply_volume_from_slider()

func _apply_volume_from_slider():
	_on_volume_changed(h_slider.value)
	
func _input(event: InputEvent) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
