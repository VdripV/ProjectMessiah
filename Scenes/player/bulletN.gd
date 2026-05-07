extends RigidBody3D

@onready var mesh: MeshInstance3D = $foamBulletA
@onready var ray: RayCast3D = $RayCast3D

const SPEED = 40.0
var Damage: int = 0

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
		body.Hit_Successful(Damage)
		queue_free()
	
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
