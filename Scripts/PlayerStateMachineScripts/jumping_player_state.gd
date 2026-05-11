class_name JumpingPlayerState

extends State

@export var SPEED : float = 3.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var JUMP_VELOCITY : float = 8.0
@export var ANIMATION : AnimationPlayer

func enter() -> void:
	global.player.velocity.y = JUMP_VELOCITY
	ANIMATION.play('JumpStart_')
	global.player.jump_sound.play()
	
func physics_update(delta: float) -> void:
	global.player.velocity += global.player.get_gravity() * delta
	if global.player.is_on_floor():
		ANIMATION.play('JumpEnd_')
		transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("sprint"):  # Теперь это активация рывка
		# Проверяем, можно ли использовать рывок
		var dashing_state = get_node("..").states.get("DashingPlayerState")
		if dashing_state and dashing_state.can_dash:
			transition.emit("DashingPlayerState")
