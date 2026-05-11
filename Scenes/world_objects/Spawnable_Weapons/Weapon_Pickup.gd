extends RigidBody3D

@export var weapon_name: String
@export var current_ammo: int
@export var reserve_ammo: int

var Pick_Up_Ready: bool = false

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	Pick_Up_Ready = true
