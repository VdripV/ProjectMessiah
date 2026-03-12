extends Node3D


const SPEED = 40.0
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0,-SPEED) * delta
