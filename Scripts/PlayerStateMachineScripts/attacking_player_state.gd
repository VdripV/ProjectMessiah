extends State

@onready var weapons: Node3D = $"../../CameraController/Camera3D/Weapons"

var bullet = load("res://Scenes/player/bullet.tscn")
var instance

func enter() -> void:
	fire_bullet()
	
	await get_tree().create_timer(0.2).timeout
	transition.emit("IdlePlayerState")

func fire_bullet() -> void:
	var instance = bullet.instantiate()
	instance.position = global.player.global_position
	instance.transform.basis = global.player.global_transform.basis
	get_parent().add_child(instance)
