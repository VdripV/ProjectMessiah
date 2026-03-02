class_name CrouchingPlayerState

extends State

@export var CROUCH_SPEED: float = 4.0
@export var ANIMATION: AnimationPlayer
@export var ANIMATION_arms: AnimationPlayer

@onready var CROUCH_SHAPECAST: ShapeCast3D = $"../../ShapeCast3D"

var is_uncrouching: bool = false

func enter() -> void:
	is_uncrouching = false
	global.player.is_crouching = true
	ANIMATION.play("crouching", -1, CROUCH_SPEED)
	await ANIMATION.animation_finished

func exit() -> void:
	global.player.is_crouching = false
	
func update(delta: float) -> void:
	if is_uncrouching:
		return
		
	if global.player.velocity.length() > 0.0 and global.player.is_on_floor():
		ANIMATION_arms.play('Hands|Hands|Walk_2')
	else:
		ANIMATION_arms.play('Hands|Hands|Idle')
		
	if Input.is_action_just_pressed('crouch'):
		try_uncrouch()
		
func try_uncrouch():
	if CROUCH_SHAPECAST.is_colliding():
		return
	
	is_uncrouching = true
	ANIMATION.play('crouching', -1, -CROUCH_SPEED, true)
	await ANIMATION.animation_finished
	
	if global.player.velocity.length() == 0:
		transition.emit("IdlePlayerState")
	else:
		transition.emit("WalkingPlayerState")
