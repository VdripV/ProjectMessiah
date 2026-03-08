class_name WalkingPlayerState

extends State

@export var ANIMATION : AnimationPlayer
@export var TOP_ANIM_SPEED: float = 1.6


func enter() -> void:
	ANIMATION.play("Walking", -1, 1)
	global.player._speed = global.player.SPEED_DEFAULT
	global.player.current_acceleration = global.player.ACCELERATION
	global.player.footstep_walk.play()
		
func exit() -> void:
	global.player.footstep_walk.stop()

func _on_animation_looped(anim_name: String):
	pass	

func update(delta: float) -> void:
	set_animation_speed(global.player.velocity.length())
	if global.player.velocity.length() == 0:
		if global.player.is_crouching:
			transition.emit("CrouchingPlayerState")
		else:
			transition.emit("IdlePlayerState")
		
		return
	
	if Input.is_action_just_pressed("jump") and global.player.is_on_floor() and !global.player.is_crouching:
		transition.emit("JumpingPlayerState")
	if Input.is_action_just_pressed("crouch") and global.player.is_on_floor():
		transition.emit("CrouchingPlayerState")
	if Input.is_action_pressed("sprint") and global.player.is_on_floor():
		transition.emit("SprintingPlayerState")
		
func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, global.player._speed, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
