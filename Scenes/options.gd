extends Control

func _input(event: InputEvent) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
