extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


const SPEED = 3.0
const ATTACK_RANGE = 2.5
const DETECTION_RANGE = 20.0

enum STATE {
	IDLE,
	RUN,
	ATTACK,
	DEATH
}

var Health = 5
var current_state : STATE = STATE.IDLE

func _ready() -> void:
	set_state(STATE.IDLE)
	
func _physics_process(delta: float) -> void:
	
	match current_state:
		STATE.IDLE:
			handle_idle_state()
		STATE.RUN:
			handle_run_state(delta)
		STATE.ATTACK:
			handle_attack_state()
	
	#velocity = Vector3.ZERO
	#nav_agent.set_target_position(global.player.global_transform.origin)
	#var next_nav_point = nav_agent.get_next_path_position()
	#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	#look_at(Vector3(global.player.global_position.x, global_position.y, global.player.global_position.z), Vector3.UP)
	#move_and_slide()

func target_in_range():
	return global_position.distance_to(global.player.global_position) < ATTACK_RANGE


func handle_idle_state():
	velocity = Vector3.ZERO
	move_and_slide()
	
	if can_see_player():
		set_state(STATE.RUN)

func handle_run_state(delta):
	nav_agent.set_target_position(global.player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(Vector3(global.player.global_position.x, global_position.y, global.player.global_position.z), Vector3.UP)
	
	move_and_slide()
	
	if target_in_range():
		set_state(STATE.ATTACK)

func handle_attack_state():
	velocity = Vector3.ZERO
	look_at(Vector3(global.player.global_position.x, global_position.y, global.player.global_position.z), Vector3.UP)
	move_and_slide()
	animation_player.play("attack")
	await animation_player.animation_finished

	if not target_in_range():
		set_state(STATE.RUN)

func set_state(new_state: STATE):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		STATE.IDLE:
			animation_player.play("idle")
		STATE.RUN:
			animation_player.play("run")
		STATE.ATTACK:
			animation_player.play("attack")
		STATE.DEATH:
			animation_player.play("dying")

func can_see_player():
	return global_position.distance_to(global.player.global_position) < DETECTION_RANGE


#state.dying coming soon...


func Hit_Successful(Damage, _Direction:=Vector3.ZERO, _Position:= Vector3.ZERO):

	Health -= Damage
	print("Target Health: " + str(Health))
	if Health <= 0:
		queue_free()
