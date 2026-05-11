class_name SlidingPlayerState

extends State

@export var SPEED: float = 9.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var TILT_AMOUNT: float = 0.09
@export_range(1, 6, 0.1) var SLIDE_ANIM_SPEED: float = 4.0
@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
@onready var CROUCH_SHAPECAST: ShapeCast3D = $"../../ShapeCast3D"


func enter() -> void:
	#set_tilt(global.player._player_rotation.z)
	animation.get_animation("crouching").track_set_key_value(4,0,global.player.velocity.length())
	animation.speed_scale = 1.0
	animation.play("crouching", -1.0, SLIDE_ANIM_SPEED)

func exit() -> void:
	pass
	
func update(delta: float) -> void:
	animation.play("crouching", -1.0, -SLIDE_ANIM_SPEED, true)
	
	if Input.is_action_just_pressed("jump") and global.player.is_on_floor():
		transition.emit("JumpingPlayerState")
		
	await animation.animation_finished
	
	if global.player.velocity.length() == 0:
		transition.emit("IdlePlayerState")
	else:
		transition.emit("WalkingPlayerState")

func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	tilt.z = clamp(TILT_AMOUNT * player_rotation, -0.1, 0.1)
	if tilt.z == 0.0:
		tilt.z = 0.05
	animation.get_animation("crouching").track_set_key_value(8,1,tilt)
	animation.get_animation("crouching").track_set_key_value(8,2,tilt)
