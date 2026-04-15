extends Control

@onready var main_menu = $CanvasLayer/MainMenu

func _input(event: InputEvent) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_level1.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/options.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_host_pressed() -> void:
	pass # Replace with function body.


func _on_join_pressed() -> void:
	pass # Replace with function body.
