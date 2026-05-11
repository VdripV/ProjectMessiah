class_name IdlePlayerState

extends State

@export var ANIMATION : AnimationPlayer
@onready var JUMP_SHAPECAST: ShapeCast3D = $"../../ShapeCast3D"

func enter() -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == 'JumpEnd_':
		await ANIMATION.animation_finished
		ANIMATION.pause()
	else:
		ANIMATION.pause()
		

func update(delta: float) -> void:
	print(global.player)
	if global.player.velocity.length() > 0.0 and global.player.is_on_floor():
		if global.player.is_crouching:
			transition.emit("CrouchingPlayerState")
		else:
			transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("jump") and global.player.is_on_floor() and !global.player.is_crouching and !JUMP_SHAPECAST.is_colliding():
		transition.emit("JumpingPlayerState")
	
	#if Input.is_action_just_pressed("crouch") and global.player.is_on_floor():
		#transition.emit("CrouchingPlayerState")
	
