extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

const SPEED = 2.0

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(global.player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	move_and_slide()
