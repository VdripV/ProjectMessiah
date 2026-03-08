class_name SprintingPlayerState

extends State

@export var ANIMATION : AnimationPlayer
@export var TOP_ANIM_SPEED : float = 1.0
var was_moving: bool = false

func enter() -> void:
	ANIMATION.play('Sprinting', -1, 1)
	global.player._speed = global.player.SPEED_SPRINT
	global.player.current_acceleration = global.player.ACCELERATION_SPRINT
	global.player.is_sprinting = true
	global.player.footstep_sprint.play()

func exit() -> void:
	global.player.is_sprinting = false
	global.player.footstep_sprint.stop()

func update(delta) -> void:
	set_animation_speed(global.player.velocity.length())
	
	if global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("jump") and global.player.is_on_floor() and !global.player.is_crouching:
		transition.emit("JumpingPlayerState")
	
	if Input.is_action_just_pressed("crouch") and global.player.is_on_floor():
		transition.emit("CrouchingPlayerState")
		
func set_animation_speed(spd) -> void:
	var alpha = remap(spd, 0.0, global.player._speed, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)

func _input(event: InputEvent) -> void:
	if event.is_action_released("sprint"):
		transition.emit("WalkingPlayerState")
